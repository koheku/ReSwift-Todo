//
//  AppDelegate.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 15/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit
import SwiftFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var navigationController: UINavigationController {
        return window!.rootViewController as! UINavigationController
    }
    
    lazy var todosViewController: TodosViewController = {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodosViewController") as! TodosViewController
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let store = MainStore(reducer: TodosReducer(), appState: AppState())
        store.dispatch(AddTodo(text: "test"))
        store.dispatch(AddTodo(text: "test"))
        store.dispatch(AddTodo(text: "test"))
        store.dispatch(AddTodo(text: "test"))
        todosViewController.store = store
        
        navigationController.viewControllers = [todosViewController]
        
        return true
    }
}