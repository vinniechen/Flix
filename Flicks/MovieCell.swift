//
//  MovieCell.swift
//  Flicks
//
//  Created by Vinnie Chen on 11/15/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
