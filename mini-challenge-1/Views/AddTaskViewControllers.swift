//
//  AddTaskViewControllersViewController.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 08/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class AddTaskViewControllers: UIViewController {

    var flagging: String?
    var helper = Helper()
    
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var nameOfGoals: UILabel!
    @IBOutlet weak var taskNameInput: UITextField!
    @IBOutlet weak var durationToFinishTask: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var tempTasks: Tasks = Tasks.init(distraction: 10, duration: 10, goalId: "123", id: "123", start: "1", status: false, taskName: "22 ")
    
    var dataGoalsId: String = ""
    var goalName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameInput.setPadding()
        taskNameInput.setupTextField()
        
        durationToFinishTask.setupTextField()
        durationToFinishTask.setPadding()
        
        startTimeField.delegate = self
        startTimeField.setupTextField()
        startTimeField.setPadding()
        
        if flagging == "edit" {
            setUpData(taskData: tempTasks)
        } else {
            labelTask.text = "Add task for \"\(goalName)\""
            navigationBar.topItem?.title = "Add Task"
        }
    }
    
    func setUpData(taskData: Tasks?) {
        taskNameInput.text = taskData?.taskName
        durationToFinishTask.text = "\(taskData?.duration ?? 0)"
        startTimeField.text = "\(taskData?.start ?? "0")"
        labelTask.text = "Edit task \"\(taskData?.taskName ?? "Wrong")\""
        navigationBar.topItem?.title = "Edit Task"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if checkMandatoryFields() == false {
            showAlert(message: "all data must be filled")
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskId = helper.countingTaskData(entity: "Task", conditional: "")
        
        tempTasks.taskName = taskNameInput.text!
        tempTasks.distraction = 0
        tempTasks.goalId = dataGoalsId
        tempTasks.id = "\(taskId)"
        tempTasks.status = false
        tempTasks.start = startTimeField.text ?? ""
        tempTasks.duration = (durationToFinishTask.text! as NSString).integerValue
        
        print("Datanya Dicky: \(tempTasks)")
        let code = helper.storeData(entity: "Task", dataGoals: nil, dataTask: tempTasks)
        
        if code != "00" {
            showAlert(message: "Data could'n be save. Try again later")
        } else {
            let destination = segue.destination as! ViewController
            destination.getTaskData()
            dismiss(animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Error saving task", message: message, preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension AddTaskViewControllers: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.OpenDatePicker()
    }
}

extension AddTaskViewControllers {
    func showDate() -> Date {
        let todayDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let dateString = "\((dateFormat.string(from: todayDate))) 23:59:59"
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        guard let newDate = newDateFormatter.date(from: dateString) else { return NSDate() as Date }
        return newDate
    }
    
    func OpenDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 10
        datePicker.minimumDate = NSDate() as Date
        datePicker.maximumDate = showDate()
        startTimeField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonClick))
        let saveButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.saveButtonClick))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleButton, saveButton], animated: true)
        startTimeField.inputAccessoryView = toolbar
    }
    
    @objc func cancelButtonClick() {
        startTimeField.resignFirstResponder()
    }
    
    @objc func saveButtonClick() {
        if let datePicker = startTimeField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            startTimeField.text = dateFormatter.string(from: datePicker.date)
        }
        startTimeField.resignFirstResponder()
    }
}
