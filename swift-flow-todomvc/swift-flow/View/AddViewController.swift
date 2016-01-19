//
//  AddViewController.swift
//  swift-flow-todomvc
//
//  Created by Paul-Henri Koeck on 19/01/16.
//  Copyright © 2016 Paul-Henri Koeck. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

	var todoText: String {
		return textField.text!
	}

    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        textField.becomeFirstResponder()
    }
}