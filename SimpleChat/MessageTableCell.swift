//
//  MessageTableCell.swift
//  DumbChat
//
//  Created by Hayden Conlin-Mouat on 2020-03-04.
//  Copyright © 2020 Hayden Conlin-Mouat. All rights reserved.
import UIKit

class MessageTableCell: UITableViewCell {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
