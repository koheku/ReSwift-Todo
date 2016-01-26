//
//  TodoTableViewCellNode.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 25/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import AsyncDisplayKit

class TodoTableViewCellNode: ASCellNode {

    struct ViewData {
        let id: Int
        let text: String
        let completed: Bool
        let dispatchCompleteTodo: ((id: Int) -> Void)
    }
    
    let checkbox: RadioButtonNode = RadioButtonNode()
    let todoText: ASTextNode = ASTextNode()
    var viewData: ViewData? {
        didSet {
            todoText.attributedString = NSAttributedString(text: viewData?.text, completed: viewData?.completed)
            checkbox.selected = viewData?.completed ?? false
        }
    }
    
    override init() {
        super.init()
        
        self.selectionStyle = .None
        self.checkbox.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10)
        self.checkbox.addTarget(self, action: "checkboxTapped", forControlEvents: .TouchUpInside)
        self.addSubnode(self.checkbox)
        self.addSubnode(self.todoText)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stackLayoutSpec = ASStackLayoutSpec(
            direction: .Horizontal,
            spacing: 14.0,
            justifyContent: .Start,
            alignItems: .Center,
            children: [self.checkbox, self.todoText]
        )
        
        let contentLayoutSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(11, 15, 11, 15),
            child: stackLayoutSpec
        )
        
        return contentLayoutSpec
    }
    
    func checkboxTapped() {
        self.viewData?.dispatchCompleteTodo(id: self.viewData!.id)
    }
}

class RadioButtonNode: ASImageNode {
    
    override var selected: Bool {
        didSet {
            self.image = UIImage(named: imageName(self.selected))
        }
    }
    
    func imageName(selected: Bool) -> String {
        return selected ? "radio-button-selected" : "radio-button"
    }
    
    override init() {
        super.init()
        self.image = UIImage(named: imageName(false))
    }
}

extension NSAttributedString {
    
    convenience init(text: String?, completed: Bool?) {
        guard let text = text, completed = completed else {
            self.init()
            return
        }
        
        var attributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!
        ]
        
        if completed {
            attributes[NSStrikethroughStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
        }
        
        self.init(string: text, attributes: attributes)
    }
}

extension TodoTableViewCellNode.ViewData {
    init(todo: Todo, dispatchCompleteTodo: ((id: Int) -> Void)) {
        self.id = todo.id
        self.text = todo.text
        self.completed = todo.completed
        self.dispatchCompleteTodo = dispatchCompleteTodo
    }
}