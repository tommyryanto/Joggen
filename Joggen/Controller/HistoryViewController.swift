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
    
    @IBOutlet weak var statusGoal: UISegmentedControl!
    
    var week: Target?
    var achived: [Achived]?
    
    @IBAction func back(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        filterData()
        historyTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayComp = DateComponents(day: -9)
        let date = Calendar.current.date(byAdding: dayComp, to: Date())*/
        
        //DataHandler.saveTarget(date: date!, distance: 1, session_per_week: 1, duration: 1, id: 3, session_count: 3, jog_interval: 10, walk_interval: 10)
        
        /*let target = DataHandler.retrieveTarget()
        
        for i in 0...(target?.count)! - 1 {
            weekHistory.append(target![i])
        }*/
        
        filterData()
        achived = DataHandler.retrieveAchived()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }
    
    func filterData() {
        let target = DataHandler.retrieveTarget()
        //var filteredData: [Achived]?
        weekHistory.removeAll()
        let dayComp = DateComponents(day: -7)
        let date = Calendar.current.date(byAdding: dayComp, to: Date())
        if statusGoal.selectedSegmentIndex == 0 {
            //ongoing
            if !target!.isEmpty {
                for i in 0...target!.count - 1 {
                    if (target?[i].week!.date_start)! >= date! {
                        weekHistory.append(target![i])
                    }
                }
            }
        } else {
            //completed
            if !target!.isEmpty{
                for i in 0...target!.count - 1 {
                    if (target?[i].week!.date_start)! < date! {
                        weekHistory.append(target![i])
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passing data
        if segue.identifier == "detail" {
            let destination = segue.destination as! DetailHistoryViewController
            destination.week = self.week
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "cell") as! WeekHistoryTableViewCell
        let history = weekHistory[indexPath.row]
        cell.week.text = "Week \((history.week?.id)!)"
        
        cell.viewBack.layer.cornerRadius = 5
        
        var achivedTotal: Achived?
        
        if !achived!.isEmpty {
            for i in 0...achived!.count - 1 {
                if achived![i].week?.id == history.week?.id {
                    achivedTotal = achived![i]
                    break
                }
            }
        }
        
        var barView = cell.sessionProgress
        var percentage = CGFloat(history.session_per_week) / 3 * cell.total.frame.width
        
        //configure session progress bar
        barView!.frame.size.width = percentage
        
        //configure duration progress bar
        percentage = CGFloat(achivedTotal.duration ?? 0) / CGFloat(history.duration) * cell.total.frame.width
        barView = cell.durationProgress
        barView!.frame = CGRect(x: (barView?.frame.origin.x)!, y: (barView?.frame.origin.y)!, width: percentage, height: barView!.frame.height)
        
        //configure distance progress bar
        barView = cell.durationProgress
        percentage = CGFloat(history.distance) / 100 * cell.total.frame.width
        barView!.frame.size.width = percentage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        week = weekHistory[indexPath.row]
        performSegue(withIdentifier: "detail", sender: self)
    }
    
}
