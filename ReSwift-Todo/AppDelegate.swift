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

    var navigationController: UINavigationController {
        return window!.rootViewController as! UINavigationController
    }
    
    lazy var todosViewController: TodosViewController = {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodosViewController") as! TodosViewController
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let store = MainStore(reducer: TodosReducer(), state: AppState())
        store.dispatch(AddTodo(text: "Try ReSwift"))
        store.dispatch(AddTodo(text: "Buy milk"))
        store.dispatch(AddTodo(text: "Play Mario Tennis"))
        store.dispatch(AddTodo(text: "Find work"))
        store.dispatch(CompleteTodo(id: 1))
        store.dispatch(CompleteTodo(id: 3))
        todosViewController.store = store
        
        navigationController.viewControllers = [todosViewController]
        
        return true
    }
}