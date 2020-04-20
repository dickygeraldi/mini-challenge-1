//
//  EditGoalViewController.swift
//  mini-challenge-1
//
//  Created by Michael Sanjaya on 13/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class EditGoalViewController: UIViewController {

    var delegate: goalsData?

    var goalId: String?
    var goalName: String?

    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var goalInput: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        deleteButton.layer.cornerRadius = 10
        viewBox.layer.cornerRadius = 10
        editButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 0.5
        
        goalInput.text = goalName!
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func editGoal(_ sender: Any) {
        print(goalInput.text!)
                if(goalInput.text == ""){
                    let alert = UIAlertController(title: "Missing Goal Name", message: "Please input the goal name!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.delegate?.updateGoalNameData(entity: "Goal", uniqueId: self.goalId!, newName: goalInput.text!)
                    let alert = UIAlertController(title: "Edit Goal Successful", message: "Goal updated successfully", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        super.dismiss(animated: true)
                        self.delegate?.reloadCollection()
                        self.delegate?.refreshGoalData()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
    }
    
    
    @IBAction func deleteGoal(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Goal", message: "Are you sure you want to delete this goal - \(self.goalName!)?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.delegate?.deleteGoalData(entity: "Goal", uniqueId: self.goalId!)
            super.dismiss(animated: true)
            self.delegate?.reloadCollection()
            self.delegate?.refreshGoalData()
            self.delegate?.reloadTable()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissSegueButton(_ sender: Any) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
