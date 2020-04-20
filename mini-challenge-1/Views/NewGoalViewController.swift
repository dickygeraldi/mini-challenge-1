//
//  NewGoalViewController.swift
//  mini-challenge-1
//
//  Created by Michael Sanjaya on 07/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController {
    var delegate: goalsData?
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var goalInput: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addGoal: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewBox.layer.cornerRadius = 10
        addGoal.layer.cornerRadius = 10
        cancel.layer.cornerRadius = 10
        cancel.layer.borderWidth = 0.5
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
    
    @IBAction func addGoalButton(_ sender: Any) {
        
        print(goalInput.text!)
        if(goalInput.text == ""){
            let alert = UIAlertController(title: "Missing Goal Name", message: "Please input the goal name!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.delegate?.storeDataToGoal(entity: "Goal", name: goalInput.text!, status: false)
            let alert = UIAlertController(title: "Add Goal Successful", message: "Goal added successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                super.dismiss(animated: true)
                self.delegate?.reloadCollection()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
//            dismiss(animated:true)
        }
        
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
