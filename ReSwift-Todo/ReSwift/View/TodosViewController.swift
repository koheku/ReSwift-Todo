//
//  ViewController.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import AsyncDisplayKit
import ReSwift
import Dwifft

class TodosViewController: UIViewController, StoreSubscriber, ASTableDataSource, ASTableDelegate {
    
    var store: MainStore<AppState>?
    var tableView: ASTableView
    var filterSegmentedControl: UISegmentedControl
    var diffCalculator: TableViewDiffCalculator<Todo>?
    var filteredTodos: [Todo] = [] {
        didSet {
            self.diffCalculator?.rows = filteredTodos
        }
    }
    
    override required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.tableView = ASTableView()
        self.filterSegmentedControl = UISegmentedControl(items: ["All", "Active", "Completed"])
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.asyncDelegate = self
        self.tableView.asyncDataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("No storyboards here.")
    }
    
    // MARK: UIViewController lifecycle
    
    override func loadView() {
        super.loadView()
        self.filterSegmentedControl.addTarget(self, action: "filterValueChanged", forControlEvents: .ValueChanged)
        self.tableView.reloadData()
        
        self.diffCalculator = TableViewDiffCalculator(tableView: self.tableView, initialRows: self.filteredTodos)
        self.diffCalculator?.insertionAnimation = UITableViewRowAnimation.Fade
        self.diffCalculator?.deletionAnimation = UITableViewRowAnimation.Fade
        
        self.view.addSubview(self.filterSegmentedControl)
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        let size = self.view.bounds.size
        self.filterSegmentedControl.frame = CGRectMake(0, 100, size.width, 40)
        self.tableView.frame = CGRectMake(0, 140, size.width, size.height-140)
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
    
    // MARK: ASTableDataSource, ASTableDelegate
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let node = ASTextCellNode()
        node.text = self.filteredTodos[indexPath.row].text
        
        return node
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTodos.count
    }
    
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.store?.dispatch(DeleteTodo(id: self.filteredTodos[indexPath.row].id))
	}

//	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TodoTableViewCell
//        cell.viewData = TodoTableViewCell.ViewData(
//            todo: self.filteredTodos[indexPath.row],
//            completeTodo: { self.store?.dispatch(CompleteTodo(id: $0))}
//        )
//		return cell
//	}
}