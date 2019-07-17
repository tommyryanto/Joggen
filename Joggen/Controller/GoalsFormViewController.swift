//
//  GoalsFormViewController.swift
//  Joggen
//
//  Created by Frederic Orlando on 16/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class GoalsFormViewController: UIViewController {
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var sessionTxt: UITextField!
    @IBOutlet weak var durationTxt: UITextField!
    @IBOutlet weak var distanceTxt: UITextField!
    @IBOutlet weak var intervalJogTxt: UITextField!
    @IBOutlet weak var intervalWalkTxt: UITextField!
    
    private var datePicker: UIDatePicker?
    
    var interval : [Int] = []
    var intervalType : [String] = []
    
    @IBOutlet weak var barView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
        
        toolBar.setItems([space, doneButton], animated: false)
        
        // input date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTxt.inputView = datePicker
        
        dateTxt.inputAccessoryView = toolBar
        sessionTxt.inputAccessoryView = toolBar
        durationTxt.inputAccessoryView = toolBar
        distanceTxt.inputAccessoryView = toolBar
        intervalJogTxt.inputAccessoryView = toolBar
        intervalWalkTxt.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func saveData() {
        let sessionPerWeek = Int32(sessionTxt.text!)!
        let durationPerSession = Int32(durationTxt.text!)!
        let distance = Float(distanceTxt.text!)!
        let intervalJogging = Int32(intervalJogTxt.text!)!
        let intervalWalking = Int32(intervalWalkTxt.text!)!
        let dateGoal = datePicker?.date
        
        let dayComp = DateComponents(day: +7)
        
        var date = Calendar.current.date(byAdding: dayComp, to: Date())!
        var week: Int = 1
        
        while dateGoal! > date {
            week += 1
            date = Calendar.current.date(byAdding: dayComp, to: date)!
        }
        
        DataHandler.saveTarget(date: Date(), distance: Float(distance), session_per_week: sessionPerWeek, duration: durationPerSession, id: Int16(week), session_count: sessionPerWeek, jog_interval: intervalJogging, walk_interval: intervalWalking)
        print(week)
    }
    
    
    @IBAction func doneJogging(_ sender: Any) {
        generateBar()
    }
    
    @IBAction func doneWalking(_ sender: Any) {
        generateBar()
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        //var startDate : Date
        saveData()
    }
    
    func generateBar() {
        intervalType = []
        interval = []
        
        let duration = Int(durationTxt.text!)!
        calculateInterval(duration: duration, jogging: Int(intervalJogTxt.text!)!, walk: Int(intervalWalkTxt.text!)!)
        print("")
        for index in 0..<interval.count
        {
            print(String(interval[index]) + " --- " + intervalType[index])
        }
        
        var bar: [UIView] = []
        var x, width : CGFloat
        let y: CGFloat = 0
        let fullWidth: CGFloat = 350, fullHeight: CGFloat = 30
        for index in 0..<interval.count
        {
            if index == 0
            {
                x = 0
            }
            else
            {
                x = bar[index-1].frame.maxX
            }
            
            width = CGFloat(interval[index])/CGFloat(duration) * fullWidth
            
            let newBar = UIView(frame: CGRect(x: x, y: y, width: width, height: fullHeight))
            
            if intervalType[index] == "Walk"
            {
                newBar.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.2196078431, blue: 0.168627451, alpha: 1)
            }
            else
            {
                newBar.backgroundColor = #colorLiteral(red: 1, green: 0.8666666667, blue: 0.3058823529, alpha: 1)
            }
            
            barView.addSubview(newBar)
            bar.append(newBar)
        }
    }
    
    @objc func donePressed()
    {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTxt.text = dateFormatter.string(from: datePicker.date)
    }
    
    func calculateInterval(duration: Int, jogging: Int, walk: Int)
    {
        let cycle: Int = duration / (jogging + walk)
        
        for _ in 1...cycle
        {
            interval.append(walk)
            intervalType.append("Walk")
            
            interval.append(jogging)
            intervalType.append("Jogging")
        }
        
        
        let leftover : Int = duration % (jogging + walk)
        if leftover != 0
        {
            if leftover < walk * 2
            {
                if leftover < walk
                {
                    interval[interval.count-1] += leftover
                }
                else
                {
                    interval.append(walk)
                    intervalType.append("Walk")
                    interval[interval.count-2] += leftover - walk
                }
            }
            else
            {
                interval.append(walk)
                intervalType.append("Walk")
                interval.append(leftover - walk)
                intervalType.append("Jogging")
            }
        }
    }
    @IBAction func generatePressed(_ sender: UIButton) {
        saveData()
        performSegue(withIdentifier: "back", sender: self)
    }
}
