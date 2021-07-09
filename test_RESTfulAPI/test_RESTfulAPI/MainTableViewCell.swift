//
//  MainTableViewCell.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/5/11.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStreetNumber: UILabel!
    @IBOutlet weak var userStreetName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
