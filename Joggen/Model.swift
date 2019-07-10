//
//  Model.swift
//  Joggen
//
//  Created by Tommy Ryanto on 10/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import Foundation

let menuData: [HomeMenu] = [HomeMenu(title: "Total Duration", record: 10, total: "90", min: true), HomeMenu(title: "Session", record: 1, total: "3x", min: false),
HomeMenu(title: "Jogging", record: 5, total: "10", min: true),
HomeMenu(title: "Walking", record: 5, total: "5", min: true)]

struct HomeMenu {
    var title: String
    var record: Int
    var total: String
    var min: Bool
    init(title: String, record: Int, total: String, min: Bool) {
        self.title = title
        self.record = record
        self.total = total
        self.min = min
    }
}
