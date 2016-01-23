//
//  TodoActions.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import ReSwift

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
    let id: Int
    let text: String
}

struct CompleteTodo: Action {
    
    static let type = "COMPLETE_TODO"
    let id: Int
}

struct CompleteAll: Action {
    
    static let type = "COMPLETE_ALL"
}

struct ClearCompleted: Action {
    
    static let type = "CLEAR_COMPLETED"
}

struct SetVisibilityFilter: Action {
    
    static let type = "SET_VISIBILITY_FILTER"
    let visibilityFilter: VisibilityFilter
}