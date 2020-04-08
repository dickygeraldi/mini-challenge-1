//
//  AddTaskViewControllersViewController.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 08/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class AddTaskViewControllers: UIViewController {

    @IBOutlet weak var nameOfGoals: UILabel!
    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var durationToFinishTask: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    
    var tempTasks: Tasks? 
    var dataGoalsId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameInput.setPadding()
        taskNameInput.setupTextField()
        
        durationToFinishTask.setupTextField()
        durationToFinishTask.setPadding()
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if checkMandatoryFields() == true {
            
            tempTasks?.taskName = taskNameInput.text!
            tempTasks?.distraction = 0
            tempTasks?.goalId = dataGoalsId
            tempTasks?.id = randomString(length: 6)
            tempTasks?.status = false
//            tempTasks?.duration = startTime.date
        
        } else {
            
            showAlert(message: "all data must be filled")
        
        }
    }
    
    func checkMandatoryFields() -> Bool {
        if taskNameInput.text == "" || durationToFinishTask.text == "" {
            return false
        } else {
            return true
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error Dialog", message: message, preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

