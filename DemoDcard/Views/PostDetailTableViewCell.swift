//
//  PostDetailTableViewCell.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/9.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
