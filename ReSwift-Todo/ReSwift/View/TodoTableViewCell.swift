//
//  TodoTableViewCell.swift
//  ReSwift-Todo
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
        let completeTodo: ((id: Int) -> Void)
    }
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    
    var viewData: ViewData? {
        didSet {
            todoLabel.attributedText = self.todoAttributedText(viewData?.text, completed: viewData?.completed)
            checkboxButton.selected = viewData?.completed ?? false
        }
    }
    
    func todoAttributedText (text: String?, completed: Bool?) -> NSAttributedString {
        guard let text = text, completed = completed else { return NSAttributedString() }
        
        let attributes: [String : AnyObject]
        if completed {
            attributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        } else {
            attributes = [:]
        }

        return NSAttributedString(string: text, attributes: attributes)
    }
    
    @IBAction func checkboxTapped(sender: UIButton) {
        self.viewData?.completeTodo(id: (self.viewData?.id)!)
    }
}

extension TodoTableViewCell.ViewData {
    init(todo: Todo, completeTodo: ((id: Int) -> Void)) {
        self.id = todo.id
        self.text = todo.text
        self.completed = todo.completed
        self.completeTodo = completeTodo
    }
}