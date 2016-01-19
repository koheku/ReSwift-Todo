//
//  TodoTableViewCell.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 19/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    struct ViewData {
        let text: String
        let completed: Bool
    }
    
    var viewData: ViewData? {
        didSet {
            textLabel!.text = viewData?.text
        }
    }
}

extension TodoTableViewCell.ViewData {
    init(todo: Todo) {
        self.text = todo.text
        self.completed = false
    }
}