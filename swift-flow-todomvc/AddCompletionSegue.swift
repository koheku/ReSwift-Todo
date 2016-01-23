//
//  AddCompletionSegue.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 19/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit

class AddCompletionSegue: UIStoryboardSegue {
	var todoText: String {
		return addViewController.todoText
	}

	private var addViewController: AddViewController {
		return sourceViewController as! AddViewController
	}
}