//
//  TodosState.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import SwiftFlow

struct Todo {
    var text: String
    var completed: Bool
    var id: Int
}

extension Todo: Equatable {}

func ==(lhs: Todo, rhs: Todo) -> Bool {
    return lhs.text == rhs.text && lhs.completed == rhs.completed && lhs.id == rhs.id
}

struct TodosState {
    var todos: [Todo] = []
}

protocol HasTodosState {
    var todosState: TodosState { get set}
    init()
}
