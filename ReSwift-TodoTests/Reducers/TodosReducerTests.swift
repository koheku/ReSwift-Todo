//
//  TodosReducerTests.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import XCTest
import ReSwift

extension HasTodosState {
    init(_ todos: [Todo]) {
        self.init()
        self.todosState = TodosState(todos: todos, visibilityFilter: .All)
    }
}

class TodosReducerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: ADD_TODO

    func testAddingOneTodoToEmptyState() {
        // Given
        let emptyState = AppState()
        let addTodo = AddTodo(text: "todo text")
        
        // When
        let result = TodosReducer().handleAction(emptyState, action: addTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos, [Todo(text: "todo text", completed: false, id: 0)])
    }
    
    func testAddingOneTodoToOneTodo() {
        // Given
        let todos = [Todo(text: "existing todo", completed: true, id: 0)]
        let addTodo = AddTodo(text: "new todo")
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: addTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos, todos + [Todo(text: "new todo", completed: false, id: 1)])
    }
    
    func testAddingOneTodoToTwoTodos() {
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let addTodo = AddTodo(text: "todo 3")
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: addTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos, todos + [Todo(text: "todo 3", completed: false, id: 2)])
    }
    
    // MARK: DELETE_TODO
    
    func testDeletingOneTodoFromTwoTodos() {
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let deleteTodo = DeleteTodo(id: 0)
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: deleteTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos, [Todo(text: "todo 2", completed: false, id: 1)])
    }
    
    // MARK: EDIT_TODO
    
    func testEditingOneTodo() {
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let editTodo = EditTodo(id: 0, text: "todo 1 was edited")
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: editTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 1 was edited", completed: true, id: 0),
                Todo(text: "todo 2", completed: false, id: 1)])
    }
    
    // MARK: COMPLETE_TODO
    
    func testCompleteOneUncompletedTodo() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: false, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let completeTodo = CompleteTodo(id: 0)
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: completeTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 1", completed: true, id: 0),
                Todo(text: "todo 2", completed: false, id: 1)])
        
    }
    
    func testCompleteOneCompletedTodo() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let completeTodo = CompleteTodo(id: 0)
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: completeTodo)
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 1", completed: false, id: 0),
                Todo(text: "todo 2", completed: false, id: 1)])
        
    }
    
    // MARK: COMPLETE_ALL
    
    func testMakeAllTodosCompleteWhenAtLeastOneTodoIsUncompleted() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: false, id: 0), Todo(text: "todo 2", completed: true, id: 1)]
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: CompleteAll())
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 1", completed: true, id: 0),
                Todo(text: "todo 2", completed: true, id: 1)])
        
    }
    
    func testMakeAllTodosUncompleteWhenAllTodosAreCompleted() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: true, id: 1)]
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: CompleteAll())
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 1", completed: false, id: 0),
                Todo(text: "todo 2", completed: false, id: 1)])
        
    }
    
    // MARK: CLEAR_COMPLETED
    
    func testClearCompletedRemovesCompletedTodos() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: true, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        
        // When
        let result = TodosReducer().handleAction(AppState(todos), action: ClearCompleted())
        
        // Then
        XCTAssertEqual(result.todosState.todos, [Todo(text: "todo 2", completed: false, id: 1)])
    }
    
    func testShouldNotGenerateDuplicateIdsAterClearCompleted() {
        
        // Given
        let todos = [Todo(text: "todo 1", completed: false, id: 0), Todo(text: "todo 2", completed: false, id: 1)]
        let actions: [Action] = [CompleteTodo(id: 0), ClearCompleted(), AddTodo(text: "todo 3")]
        
        // When
        let result = actions.reduce(AppState(todos), combine: TodosReducer().handleAction)
        
        // Then
        XCTAssertEqual(result.todosState.todos,
            [Todo(text: "todo 2", completed: false, id: 1),
                Todo(text: "todo 3", completed: false, id: 2)])
        
    }
    
    // MARK: SET_VISIBILITY_FILTER
    
    func testDefaultVisibilityFilter() {
        
        // Given
        let state = AppState()
        
        // Then
        XCTAssert(state.todosState.visibilityFilter == .All)
    }
    
    func testSetVisibilityFilter() {
        
        // Given
        let state = AppState()
        
        // When
        let result = TodosReducer().handleAction(state, action: SetVisibilityFilter(visibilityFilter: .Active))
        
        // Then
        XCTAssert(result.todosState.visibilityFilter == .Active)
    }
}