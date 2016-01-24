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
    let node = TodosViewControllerNode()
    var diffCalculator: TableViewDiffCalculator<Todo>?
    var filteredTodos: [Todo] = [] {
        didSet {
            self.diffCalculator?.rows = filteredTodos
        }
    }
    
    override required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.node.tableView.asyncDataSource = self
        self.node.tableView.asyncDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("No storyboards here.")
    }
    
    // MARK: UIViewController lifecycle
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.node.view)
        
        self.node.filterSegmentedControl.addTarget(self, action: "filterValueChanged", forControlEvents: .ValueChanged)
        self.node.tableView.reloadData()
        
        self.diffCalculator = TableViewDiffCalculator(tableView: self.node.tableView, initialRows: self.filteredTodos)
        self.diffCalculator?.insertionAnimation = UITableViewRowAnimation.Fade
        self.diffCalculator?.deletionAnimation = UITableViewRowAnimation.Fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo list"
        self.edgesForExtendedLayout = .None;
    }
    
    override func viewWillLayoutSubviews() {
        let sizeRange = ASSizeRangeMake(self.view.bounds.size, self.view.bounds.size)
        let size = self.node.measureWithSizeRange(sizeRange).size
        self.node.frame = CGRect(origin: CGPoint(), size: size)
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
        self.node.filterSegmentedControl.selectedSegmentIndex = state.todosState.visibilityFilter.rawValue
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
        guard let visibilityFilter = VisibilityFilter(rawValue: self.node.filterSegmentedControl.selectedSegmentIndex)
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