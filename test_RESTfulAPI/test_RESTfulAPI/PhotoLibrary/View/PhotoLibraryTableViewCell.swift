//
//  PhotoLibraryTableViewCell.swift
//  test_RESTfulAPI
//
//  Created by daher on 2021/7/8.
//

import UIKit

class PhotoLibraryTableViewCell: UITableViewCell {

        
    @IBOutlet var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
