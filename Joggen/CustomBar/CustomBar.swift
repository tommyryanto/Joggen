//
//  CustomBar.swift
//  Joggen
//
//  Created by Frederic Orlando on 17/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class CustomBar: UIView {

    var labelInterval = UILabel()
    let divider = UIView()
    var durationLbl = UILabel()
    var intervalType = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        barInit()
    }
    
    private func barInit()
    {
        self.addSubview(labelInterval)
        self.addSubview(divider)
        self.addSubview(intervalType)
        
        labelInterval.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        labelInterval.textAlignment = .center
        labelInterval.font = UIFont.systemFont(ofSize: 12)
        labelInterval.textColor = .white
        
        divider.frame = CGRect(x: self.frame.width-1, y: 0, width: 1, height: self.frame.height + 10)
        divider.backgroundColor = .black
        
        intervalType.frame = CGRect(x: 0, y: -self.frame.height + 7, width: self.frame.width, height: self.frame.height)
        intervalType.textAlignment = .center
        intervalType.font = UIFont.systemFont(ofSize: 12)
        intervalType.textColor = .blue
        
        divider.addSubview(durationLbl)
        
        durationLbl.frame = CGRect(x: -10, y: self.frame.height, width: 20, height: self.frame.height)
        
        durationLbl.textAlignment = .center
        durationLbl.font = UIFont.systemFont(ofSize: 12)
    }
}
