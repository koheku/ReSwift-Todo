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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let store = MainStore(reducer: TodosReducer(), appState: AppState())
        TodosReducer().handleAction(store.appState as! AppState, action: AddTodo(text: "test"))
        let todosViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("TodosViewController") as! TodosViewController
        todosViewController.store = store
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = todosViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

