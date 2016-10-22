//
//  SpeakerTableViewCell.swift
//  codemash
//
//  Created by Kim Arnett on 10/15/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import Foundation
import UIKit

class SpeakerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
   
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius: CGFloat = 53/2
        
        self.profileImg.layer.cornerRadius = radius
        self.profileImg.layer.borderColor = UIColor.clear.cgColor
        self.profileImg.layer.borderWidth = 1.0
        self.profileImg.layer.masksToBounds = true
        
    }
}
