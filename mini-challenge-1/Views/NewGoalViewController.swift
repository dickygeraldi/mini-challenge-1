//
//  NewGoalViewController.swift
//  mini-challenge-1
//
//  Created by Michael Sanjaya on 07/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController {

    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var goalInput: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addGoal: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBox.layer.cornerRadius = 10
        addGoal.layer.cornerRadius = 10
        cancel.layer.cornerRadius = 10
        cancel.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addGoalButton(_ sender: Any) {
        
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
