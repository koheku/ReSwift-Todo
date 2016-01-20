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
        let id: Int
        let text: String
        let completed: Bool
        let completeTodo: (Int -> Void)
    }
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    
    var viewData: ViewData? {
        didSet {
            todoLabel.text = viewData?.text
            checkboxButton.selected = (viewData?.completed)!
        }
    }
    
    @IBAction func checkboxTapped(sender: UIButton) {
        self.viewData?.completeTodo((self.viewData?.id)!)
    }
}

extension TodoTableViewCell.ViewData {
    init(todo: Todo, completeTodo: (Int -> Void)) {
        self.id = todo.id
        self.text = todo.text
        self.completed = todo.completed
        self.completeTodo = completeTodo
    }
}