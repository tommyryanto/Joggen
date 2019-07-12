//
//  GoalsViewController.swift
//  Joggen
//
//  Created by Tommy Ryanto on 10/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var statusGoal: UISegmentedControl!
    
    @IBAction func segmentedControl(_ sender: Any) {
        historyTableView.reloadData()
    }
    
    @IBOutlet weak var historyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        DataHandler.saveTarget(date: Date(), distance: 5.0, session_per_week: 3, duration: 40, id: 1, session_count: 5)
        let target = DataHandler.retrieveTarget()
        
        for i in 0...(target?.count)! - 1 {
            weekHistory.append(target![i])
        }
        //filterData()
    }
    
    func filterData() {
        let target = DataHandler.retrieveTarget()
        //var filteredData: [Achived]?
        
        if statusGoal.selectedSegmentIndex == 0 {
            //ongoing
            for i in 0...target!.count {
                if (target?[i].week!.date_start)! > Date() {
                    weekHistory.append(target![i])
                }
            }
        } else {
            //completed
            for i in 0...target!.count {
                if (target?[i].week!.date_start)! < Date() {
                    weekHistory.append(target![i])
                }
            }
        }
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
        cell.week.text = "Week \(history.week?.date_start)"
        
        var barView = cell.sessionProgress
        var percentage = CGFloat(history.session_per_week) / 3 * cell.total.frame.width
        
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
