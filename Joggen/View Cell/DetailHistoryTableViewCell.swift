//
//  DetailHistoryTableViewCell.swift
//  Joggen
//
//  Created by Tommy Ryanto on 15/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class DetailHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var walkInterval: UILabel!
    @IBOutlet weak var jogInterval: UILabel!
    @IBOutlet weak var calories: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
