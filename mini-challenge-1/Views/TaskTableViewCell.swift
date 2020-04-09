//
//  TaskTableViewCell.swift
//  mini-challenge-1
//
//  Created by Aries Dwi Prasetiyo on 09/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var nameTaskLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
