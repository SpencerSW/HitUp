//
//  MessageTableViewCell.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/13/24.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var receiveImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        receiveImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

