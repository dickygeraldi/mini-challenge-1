//
//  AddTaskViewControllersViewController.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 08/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class AddTaskViewControllersViewController: UIViewController {

    @IBOutlet weak var nameOfGoals: UILabel!
    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var durationToFinishTask: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameInput.setPadding()
        taskNameInput.setupTextField()
        
        durationToFinishTask.setupTextField()
        durationToFinishTask.setPadding()
    }
    
    
    
    func checkMandatoryFields() -> Bool {
        if taskNameInput.text == "" || durationToFinishTask.text == "" {
            return false
        } else {
            return true
        }
    }
}

