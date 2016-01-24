//
//  ViewController.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit
import ReSwift
import Dwifft

class TodosViewController: UIViewController, StoreSubscriber, UITableViewDataSource, UITableViewDelegate {
    
    var store: MainStore<AppState>?
    var diffCalculator: TableViewDiffCalculator<Todo>?
    var filteredTodos: [Todo] = [] {
        didSet {
            self.diffCalculator?.rows = filteredTodos
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    // MARK: UIViewController lifecycle
    
    override func loadView() {
        super.loadView()
        self.filterSegmentedControl.addTarget(self, action: "filterValueChanged", forControlEvents: .ValueChanged)
        self.diffCalculator = TableViewDiffCalculator(tableView: self.tableView, initialRows: self.filteredTodos)
        self.diffCalculator?.insertionAnimation = UITableViewRowAnimation.Fade
        self.diffCalculator?.deletionAnimation = UITableViewRowAnimation.Fade
    }
    
    override func viewWillAppear(animated: Bool) {
        self.store?.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.store?.unsubscribe(self)
    }
    
    // MARK: Store subscriber
    
    func newState(state: AppState) {
        // The filteredTodos setter triggers the Dwifft diffing (which triggers the animated table view updates)
        self.filteredTodos = filteredTodosFromState(state)
        self.filterSegmentedControl.selectedSegmentIndex = state.todosState.visibilityFilter.rawValue
    }
    
    func filteredTodosFromState(state: AppState) -> [Todo] {
        switch (state.todosState.visibilityFilter) {
        case .All:
            return state.todosState.todos
        case .Active:
            return state.todosState.todos.filter() { return $0.completed == false}
        case .Completed:
            return state.todosState.todos.filter() { return $0.completed == true }
        }
    }
    
    // MARK: Filter segmented control
    
    func filterValueChanged() {
        guard let visibilityFilter = VisibilityFilter(rawValue: self.filterSegmentedControl.selectedSegmentIndex)
        else { return }
        
        self.store?.dispatch(SetVisibilityFilter(visibilityFilter: visibilityFilter))
    }
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.store?.dispatch(DeleteTodo(id: self.filteredTodos[indexPath.row].id))
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTodos.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TodoTableViewCell
        cell.viewData = TodoTableViewCell.ViewData(
            todo: self.filteredTodos[indexPath.row],
            completeTodo: { self.store?.dispatch(CompleteTodo(id: $0))}
        )
		return cell
	}
    
    // MARK: Storyboard events
    
    @IBAction func unwindFromAddController(segue: AddCompletionSegue) {
        self.store?.dispatch(AddTodo(text: segue.todoText))
    }
    
    @IBAction func unwindFromAddControllerForDismiss(segue: AddCompletionSegue) {
    }
}