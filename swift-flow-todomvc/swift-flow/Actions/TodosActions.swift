//
//  TodoActions.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import SwiftFlow

struct AddTodo: Action {
    
    static let type = "ADD_TODO"
    let text: String
}

struct DeleteTodo: Action {
    
    static let type = "DELETE_TODO"
    let id: Int
}

struct EditTodo: Action {
    
    static let type = "EDIT_TODO"
    let id: String
    let text: String
}

struct CompleteTodo: Action {
    
    static let type = "COMPLETE_TODO"
    let id: String
}

struct CompleteAll: Action {
    
    static let type = "COMPLETE_ALL"
}

struct ClearCompleted: Action {
    
    static let type = "CLEAR_COMPLETED"
}