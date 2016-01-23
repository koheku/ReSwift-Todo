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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: UIViewController lifecycle
    
    override func loadView() {
        super.loadView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.segmentedControl.addTarget(self, action: "segmentedControlValueChanged", forControlEvents: .ValueChanged)
        self.diffCalculator = TableViewDiffCalculator(tableView: self.tableView, initialRows: self.filteredTodos)
        self.diffCalculator?.insertionAnimation = UITableViewRowAnimation.Fade
        self.diffCalculator?.deletionAnimation = UITableViewRowAnimation.Fade
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
    
    // MARK: Store subscriber
    
    func newState(state: AppState) {
        self.filteredTodos = filteredTodosFromState(state)
        self.segmentedControl.selectedSegmentIndex = state.todosState.visibilityFilter.rawValue
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
    
    // MARK: Segmented control
    
    func segmentedControlValueChanged() {
        guard let visibilityFilter = VisibilityFilter(rawValue: self.segmentedControl.selectedSegmentIndex)
        else { return }
        
        self.store?.dispatch(SetVisibilityFilter(visibilityFilter: visibilityFilter))
    }
    
    // MARK: Table view datasource and delegate
    
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