//
//  PostTableViewCell.swift
//  Instagram Clone
//
//  Created by Alex Paul on 3/26/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var pictures: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
