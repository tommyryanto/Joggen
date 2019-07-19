//
//  Model.swift
//  Joggen
//
//  Created by Tommy Ryanto on 10/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import Foundation


var menuData: [HomeMenu] = []

var targetGoals:[WeekHistory] = [WeekHistory(session: 3, distance: 4, duration: 1, week: 2), WeekHistory(session: 2, distance: 3, duration: 20, week: 1)]

//var weekHistory: [WeekHistory] = [WeekHistory(session: 3, distance: 4, duration: 1, week: 2)]
var weekHistory: [Target] = []
var achivedHistory: [Achived] = []

struct HomeMenu {
    var title: String
    var record: Int32
    var total: String
    var min: Bool
    init(title: String, record: Int32, total: String, min: Bool) {
        self.title = title
        self.record = record
        self.total = total
        self.min = min
    }
}

struct WeekHistory {
    var session: Int
    var distance: Float
    var duration: Float
    var week: Int16
    
    init(session: Int, distance: Float, duration: Float, week: Int16) {
        self.session = session
        self.distance = distance
        self.duration = duration
        self.week = week
    }
}
