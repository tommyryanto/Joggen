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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        goal = DataHandler.retrieveTarget()
        
        for i in 0...goal!.count - 1 {
            if UserDefaults.standard.integer(forKey: "week") == goal![i].week!.id {
                goalFound = goal![i]
                break
            }
        }
        
        achived = DataHandler.retrieveAchived()
        
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
        
        /*HomeMenu(title: "Total Duration", record: 10, total: "90", min: true), HomeMenu(title: "Session", record: 1, total: "3x", min: false),
        HomeMenu(title: "Jogging", record: 5, total: "10", min: true),
        HomeMenu(title: "Walking", record: 5, total: "5", min: true)*/
        
        
        if dataToShow == nil {
            let context = Achived(context: DataHandler.getContext())
            context.duration = 0
            context.jog_interval = 0
            context.walk_interval = 0
            dataToShow = context
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
