//
//  AppState.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import ReSwift

struct AppState: StateType, HasTodosState {
    var todosState = TodosState()
    init() {}
}