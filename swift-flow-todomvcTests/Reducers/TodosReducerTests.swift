//
//  TodosReducerTests.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import XCTest
import SwiftFlow

extension HasTodosState {
    init(_ todos: [Todo]) {
        self.init()
        self.todosState = TodosState(todos: todos)
    }
}

class TodosReducerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

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
}
