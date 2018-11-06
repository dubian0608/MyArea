//
//  AreaTableViewCell.swift
//  MyArea
//
//  Created by Zhang, Frank on 14/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class AreaTableViewCell: UITableViewCell {

   
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var areaImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
