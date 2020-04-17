//
//  ProfileTableViewCell.swift
//  What'sYourLook?
//
//  Created by admin on 17/04/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
