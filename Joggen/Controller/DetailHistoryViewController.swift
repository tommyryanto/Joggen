//
//  DetailHistoryViewController.swift
//  Joggen
//
//  Created by Tommy Ryanto on 15/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class DetailHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var week: Target?
    var achived: [Achived]?
    var showData: [Achived] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print((week?.distance)!)
        
        /*DataHandler.saveAchived(calories: 40, duration: 25, id: 1, jog_interval: 15, walk_interval: 10, distance: 3, session_count: 2, date_start: Date())
        DataHandler.saveAchived(calories: 25, duration: 30, id: 1, jog_interval: 10, walk_interval: 20, distance: 3, session_count: 2, date_start: Date())
 */
        
        retrieveData()
    }
    
    func retrieveData() {
        achived = DataHandler.retrieveAchived()
        
        filterData()
    }
    
    func filterData() {
        if !achived!.isEmpty {
            for i in 0...(achived?.count)! - 1{
                if achived![i].week?.id == week?.id {
                    showData.append(achived![i])
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

extension DetailHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DetailHistoryTableViewCell
        
        let data = showData[indexPath.row]
        //let date = data.week?.date_start
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy hh:mm"
        let convertedDate = dateFormatter.string(from: (data.week?.date_start)!)
        cell.date.text = "\(convertedDate)"
        cell.distance.text = "\(data.distance) m"
        
        if data.duration / 60 >= 1{
            cell.duration.text = "\(data.duration/60) minutes"
        } else {
            cell.duration.text = "\(data.duration) seconds"
        }
        
        cell.walkInterval.text = "\(data.walk_interval) minutes"
        cell.jogInterval.text = "\(data.jog_interval) minutes"
        //cell.calories.text = "\(data.calories)"
        
        return cell
    }
    
}
