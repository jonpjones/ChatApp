//
//  MessageTableViewCell.swift
//  OraCodeChallenge
//
//  Created by Jonathan Jones on 10/22/16.
//  Copyright © 2016 Jon Jones. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    enum Orientation {
        case Left
        case Right
    }
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorAndDateLabel: UILabel!
    
    var orientation = Orientation.Left
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        switch orientation {
        case .Left: formatMessageView()
        case .Right: formatMessageView()
        }
    }
    
    func formatMessageView() {
        self.messageView.layer.cornerRadius = 25        
    }
    
    
}
