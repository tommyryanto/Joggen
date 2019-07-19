//
//  ViewController.swift
//  Joggen
//
//  Created by Tommy Ryanto on 10/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var homeNavigationBar: UINavigationItem!
    
    @IBOutlet weak var startButton: UIButton!
    
    var achived: [Achived]?
    var dataToShow: Achived?
    var goal: [Target]?
    var goalFound: Target?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.integer(forKey: "week"))
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Week \(UserDefaults.standard.integer(forKey: "week"))"
        
        // Mengubah Week sesuai dengan minggu ke-X dari pertama kali digunakan (bisa pakai count data di db) 
        
        startButton.layer.borderWidth = 2.5
        startButton.layer.borderColor = UIColor(red: 65/255, green: 146/255, blue: 123/255, alpha: 1).cgColor
        startButton.layer.cornerRadius = startButton.frame.width/5
        goal = DataHandler.retrieveTarget()
        
        achived = DataHandler.retrieveAchived()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !goal!.isEmpty {
            print(goal![0])
            for i in 0...goal!.count - 1 {
                if UserDefaults.standard.integer(forKey: "week") == goal![i].week!.id {
                    goalFound = goal![i]
                    break
                }
            }
        } else {
            print("goal empty")
            /*
            let goalEmpty: Target = {
                let target = Target(context: DataHandler.getContext())
                target.duration = 0
                target.jog_interval = 0
                target.walk_interval = 0
                return target
            }()
            goalFound = goalEmpty*/
        }
        
        
        if !achived!.isEmpty {
            for i in 0...achived!.count - 1 {
                if UserDefaults.standard.integer(forKey: "week") == achived![i].week!.id {
                    dataToShow = achived![i]
                    menuData.append(HomeMenu(title: "Total Duration", record: dataToShow!.duration, total: "\(goalFound!.duration)", min: true))
                    menuData.append(HomeMenu(title: "Session", record: dataToShow!.duration, total: "\(goalFound!.duration)", min: false))
                    menuData.append(HomeMenu(title: "Jogging", record: dataToShow!.jog_interval, total: "\(goalFound!.jog_interval)", min: true))
                    menuData.append(HomeMenu(title: "Walking", record: dataToShow!.walk_interval, total: "\(goalFound!.walk_interval)", min: true))
                    break
                }
            }
        } else {
            menuData.append(HomeMenu(title: "Total Duration", record: 0, total: "0", min: true))
            menuData.append(HomeMenu(title: "Session", record: 0, total: "0", min: false))
            menuData.append(HomeMenu(title: "Jogging", record: 0, total: "0", min: true))
            menuData.append(HomeMenu(title: "Walking", record: 0, total: "0", min: true))
        }
        
        /*HomeMenu(title: "Total Duration", record: 10, total: "90", min: true), HomeMenu(title: "Session", record: 1, total: "3x", min: false),
        HomeMenu(title: "Jogging", record: 5, total: "10", min: true),
        HomeMenu(title: "Walking", record: 5, total: "5", min: true)*/
        
        
        if dataToShow == nil {
            /*let achivedEmpty : Achived = {
                let context = Achived(context: DataHandler.getContext())
                context.duration = 0
                context.jog_interval = 0
                context.walk_interval = 0
                return context
            }()
            dataToShow = achivedEmpty*/
            dataToShow?.duration = 0
            dataToShow?.jog_interval = 0
            dataToShow?.walk_interval = 0
        }
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToTracking", sender: self)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCell
        let data = menuData[indexPath.row]
        cell.title.text = data.title
        cell.min.isHidden = !data.min
        cell.record.text = "\(data.record)"
        cell.total.text = "/ \(data.total)"
        cell.viewBack.layer.cornerRadius = cell.frame.width/13
        
        return cell
    }
    
}
