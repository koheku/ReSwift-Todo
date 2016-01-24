//
//  AppDelegate.swift
//  ReSwift-Todo
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController: UINavigationController = {
        return UINavigationController()
    }()
    
    lazy var todosViewController: TodosViewController = {
        return TodosViewController(nibName: nil, bundle: nil)
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let store = MainStore(reducer: TodosReducer(), state: AppState())
        store.dispatch(AddTodo(text: "Try ReSwift"))
        store.dispatch(AddTodo(text: "Buy milk"))
        store.dispatch(AddTodo(text: "Play Mario Tennis"))
        store.dispatch(AddTodo(text: "Find work"))
        store.dispatch(CompleteTodo(id: 0))
        store.dispatch(CompleteTodo(id: 2))
        todosViewController.store = store
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = navigationController
        navigationController.viewControllers = [todosViewController]
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}