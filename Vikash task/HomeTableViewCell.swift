//
//  HomeTableViewCell.swift
//  Vikash task
//
//  Created by Vikash on 12/08/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
