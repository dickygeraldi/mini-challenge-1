//
//  EditGoalViewController.swift
//  mini-challenge-1
//
//  Created by Michael Sanjaya on 13/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class EditGoalViewController: UIViewController {

    var delegate = goalsData?
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var goalInput: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var goalId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewBox.layer.cornerRadius = 10
        editButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 0.5
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
