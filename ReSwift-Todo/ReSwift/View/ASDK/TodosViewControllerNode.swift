//
//  TodosViewControllerNode.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 24/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import AsyncDisplayKit

class TodosViewControllerNode: ASDisplayNode {
    
    let tableNode: ASTableNode
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayoutSpec = ASStackLayoutSpec(
            direction: .Vertical,
            spacing: 0,
            justifyContent: .Start,
            alignItems: ASStackLayoutAlignItems.Start,
            children: [self.tableNode]
        )
        
        return stackLayoutSpec
    }
    
    override init() {
        self.tableNode = ASTableNode()
        super.init()
    }
}