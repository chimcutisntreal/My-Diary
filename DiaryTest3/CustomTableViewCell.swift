//
//  CustomTableViewCell.swift
//  DiaryTest3
//
//  Created by Chinh on 10/9/18.
//  Copyright © 2018 Chinh. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBodyText: UILabel!
//    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var lblcreatedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //SET CORNER RADIUS
        lblcreatedAt.font = UIFont.preferredFont(forTextStyle: .footnote).italic()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
