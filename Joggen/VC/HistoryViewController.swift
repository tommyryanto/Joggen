//
//  GoalsViewController.swift
//  Joggen
//
//  Created by Tommy Ryanto on 10/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "cell") as! WeekHistoryTableViewCell
        let history = weekHistory[indexPath.row]
        cell.week.text = "Week \(history.week)"
        
        var barView = cell.sessionProgress
        var percentage = CGFloat(history.session) / 3 * cell.total.frame.width
        
        //configure session progress bar
        barView!.frame.size.width = percentage
        
        //configure duration progress bar
        percentage = CGFloat(history.duration) / 100 * cell.total.frame.width
        barView = cell.durationProgress
        barView!.frame = CGRect(x: (barView?.frame.origin.x)!, y: (barView?.frame.origin.y)!, width: percentage, height: barView!.frame.height)
        
        //configure distance progress bar
        barView = cell.durationProgress
        percentage = CGFloat(history.distance) / 100 * cell.total.frame.width
        barView!.frame.size.width = percentage
        
        return cell
    }
    
    
}
