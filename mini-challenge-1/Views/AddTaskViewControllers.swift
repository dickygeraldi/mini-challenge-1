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
    @IBOutlet weak var startTimeField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    var helper = Helper()
    
    var tempTasks: Tasks = Tasks.init(distraction: 10, duration: 10, goalId: "123", id: "123", start: "10 minutes", status: false, taskName: "Uhuyy")
    
    var dataGoalsId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameInput.setPadding()
        taskNameInput.setupTextField()
        
        durationToFinishTask.setupTextField()
        durationToFinishTask.setPadding()
        
        startTimeField.setupTextField()
        startTimeField.setPadding()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.minuteInterval = 10
        datePicker?.addTarget(self, action: #selector(AddTaskViewControllers.dateChanged(datePicker:)), for: .valueChanged)
        
        startTimeField.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTaskViewControllers.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        startTimeField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if checkMandatoryFields() == true {
            
            tempTasks.taskName = taskNameInput.text!
            tempTasks.distraction = 0
            tempTasks.goalId = dataGoalsId
            tempTasks.id = randomString(length: 6)
            tempTasks.status = false
            tempTasks.start = startTimeField.text ?? ""
        
            
        
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

