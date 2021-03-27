//
//  CommentTableViewCell.swift
//  Instagram Clone
//
//  Created by Alex Paul on 3/27/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
