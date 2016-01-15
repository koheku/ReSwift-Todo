//
//  TodosReducer.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import SwiftFlow

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
                    return Todo(text: action.text, completed: todo.completed, id: todo.id)
                }
                return todo
            })
            return state
            
        default:
            return state
        }
    }
}