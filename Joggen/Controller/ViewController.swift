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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Mengubah Week sesuai dengan minggu ke-X dari pertama kali digunakan (bisa pakai count data di db)
        homeNavigationBar.title = "Week 1"
        
        startButton.layer.borderWidth = 2.5
        startButton.layer.borderColor = UIColor(red: 65/255, green: 146/255, blue: 123/255, alpha: 1).cgColor
        startButton.layer.cornerRadius = startButton.frame.width/5
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
