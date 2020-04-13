//
//  GoalCollectionViewCell.swift
//  mini-challenge-1
//
//  Created by Michael Sanjaya on 06/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: GoalCollectionViewCell!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate : GoalCollectionViewCell?
    var goalText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.isUserInteractionEnabled = false
        
        

    }
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor(red: 225/300, green: 243/300, blue: 242/300, alpha: 1) : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            self.goalLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
            
        }
    }
    @objc func editButtonGoal(sender: Any?){
        print("Test 11")
    }

    @IBAction func editGoal(_ sender: UIButton) {

        print("test")
        
    }
}
