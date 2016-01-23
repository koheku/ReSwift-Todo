//
//  TodosState.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import ReSwift

struct Todo {
    var text: String
    var completed: Bool
    var id: Int
}

enum VisibilityFilter: Int {
    case All
    case Active
    case Completed
}

extension Todo: Equatable {}

func ==(lhs: Todo, rhs: Todo) -> Bool {
    return lhs.text == rhs.text && lhs.completed == rhs.completed && lhs.id == rhs.id
}

struct TodosState {
    var todos: [Todo] = []
    var visibilityFilter: VisibilityFilter = .All
}

protocol HasTodosState {
    var todosState: TodosState { get set}
    init()
}
