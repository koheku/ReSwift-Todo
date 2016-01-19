//
//  ViewController.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit
import SwiftFlow

class TodosViewController: UIViewController, StoreSubscriber {
    
    var store: MainStore?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.store?.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.store?.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        print(state.todosState.todos)
    }
}