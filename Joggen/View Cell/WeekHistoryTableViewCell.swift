//
//  WeekHistoryTableViewCell.swift
//  Joggen
//
//  Created by Tommy Ryanto on 11/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class WeekHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var total: UIView!
    @IBOutlet weak var durationProgress: UIView!
    @IBOutlet weak var distanceProgress: UIView!
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var sessionProgress: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
