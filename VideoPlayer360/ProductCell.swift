//
//  ProductCell.swift
//  360VideoPlayer
//
//  Created by Prianka Liz Kariat on 9/21/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

  var videoPlayer: VideoPlayer?
  var isSeeking = false
  var duration: Double = 0.0
  
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var playerView: UIView!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  

}
