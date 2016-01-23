//
//  ViewController.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit
import ReSwift

class TodosViewController: UIViewController, StoreSubscriber, UITableViewDataSource, UITableViewDelegate {
    
    var store: MainStore<AppState>?
    var todos: [Todo] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.segmentedControl.addTarget(self, action: "segmentedControlValueChanged", forControlEvents: .ValueChanged)
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
        switch (state.todosState.visibilityFilter) {
        case .All:
            self.todos = state.todosState.todos
        case .Active:
            self.todos = state.todosState.todos.filter() { return $0.completed == false
        }
        case .Completed:
            self.todos = state.todosState.todos.filter() { return $0.completed == true}
        }
        
        self.segmentedControl.selectedSegmentIndex = state.todosState.visibilityFilter.rawValue
        self.tableView.reloadData()
    }
    
    // MARK: Segmented control
    
    func segmentedControlValueChanged() {
        guard let visibilityFilter = VisibilityFilter(rawValue: self.segmentedControl.selectedSegmentIndex)
        else { return }
        
        self.store?.dispatch(SetVisibilityFilter(visibilityFilter: visibilityFilter))
    }
    
    // MARK: Table view datasource and delegate
    
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.store?.dispatch(DeleteTodo(id: self.todos[indexPath.row].id))
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TodoTableViewCell
        cell.viewData = TodoTableViewCell.ViewData(
            todo: self.todos[indexPath.row],
            completeTodo: { self.store?.dispatch(CompleteTodo(id: $0))}
        )
		return cell
	}
    
    @IBAction func unwindFromAddController(segue: AddCompletionSegue) {
        self.store?.dispatch(AddTodo(text: segue.todoText))
    }
    
    @IBAction func unwindFromAddControllerForDismiss(segue: AddCompletionSegue) {
    }
}