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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.isUserInteractionEnabled = false
    }

    @IBAction func editGoal(_ sender: Any) {
        print("test")
        
    }
}
