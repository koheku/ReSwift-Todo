//
//  TodosViewControllerNode.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 24/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import AsyncDisplayKit

class TodosViewControllerNode: ASDisplayNode {
    
    let tableNode: ASTableNode = ASTableNode()
    let filterSegmentedControlNode = ASDisplayNode { () -> UIView in
        return UISegmentedControl(items: ["All", "Active", "Completed"])
    }
    
    var filterSegmentedControl: UISegmentedControl {
        return filterSegmentedControlNode.view as! UISegmentedControl
    }
    var tableView: ASTableView {
        return tableNode.view as ASTableView
    }
    
    override init() {
        super.init()
        
        self.addSubnode(self.filterSegmentedControlNode)
        self.addSubnode(self.tableNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let segmentedControlLayoutSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(10, 10, 10, 10), child: self.filterSegmentedControlNode
        )
        
        let stackLayoutSpec = ASStackLayoutSpec(
            direction: .Vertical,
            spacing: 0,
            justifyContent: .Start,
            alignItems: .Stretch,
            children: [segmentedControlLayoutSpec, self.tableNode]
        )
        
        self.filterSegmentedControlNode.preferredFrameSize = CGSizeMake(0, 35)
        self.tableNode.flexGrow = true
        
        return stackLayoutSpec
    }
}