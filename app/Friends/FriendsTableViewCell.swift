//
//  FriendsTableViewCell.swift
//  clientVk
//
//  Created by Roman Syrchin on 11/5/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    var friend: Friend?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
