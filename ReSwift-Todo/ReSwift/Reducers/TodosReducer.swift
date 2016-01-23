//
//  TodosReducer.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import ReSwift

struct TodosReducer: Reducer {
    func handleAction(var state: HasTodosState, action: Action) -> HasTodosState {
        
        switch action {
            
        case let action as AddTodo:
            let newID = state.todosState.todos.reduce(-1, combine: {maxId, todo in max(maxId, todo.id)}) + 1
            let newTodo = Todo(text: action.text, completed: false, id: newID)
            state.todosState.todos.append(newTodo)
            return state
            
        case let action as DeleteTodo:
            state.todosState.todos = state.todosState.todos.filter({$0.id != action.id})
            return state
            
        case let action as EditTodo:
            state.todosState.todos = state.todosState.todos.map({ todo in
                if (todo.id == action.id) {
                    var newTodo = todo
                    newTodo.text = action.text
                    return newTodo
                }
                return todo
            })
            return state
            
        case let action as CompleteTodo:
            state.todosState.todos = state.todosState.todos.map({ todo in
                if (todo.id == action.id) {
                    var newTodo = todo
                    newTodo.completed = !todo.completed
                    return newTodo
                }
                return todo
            })
            return state
            
        case _ as CompleteAll:
            let areAllCompleted = todosAreAllCompleted(state.todosState.todos)
            state.todosState.todos = state.todosState.todos.map({ (var todo) in
                todo.completed = !areAllCompleted
                return todo
            })
            return state
            
        case _ as ClearCompleted:
            state.todosState.todos = state.todosState.todos.filter() { $0.completed == false }
            return state
            
        default:
            return state
        }
    }
    
    func todosAreAllCompleted (todos: [Todo]) -> Bool {
        
        var areAllCompleted = true
        for todo in todos {
            if (todo.completed == false) {
                areAllCompleted = false
                break
            }
        }
        return areAllCompleted
    }
}