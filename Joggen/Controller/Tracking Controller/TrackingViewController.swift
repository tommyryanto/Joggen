//
//  TrackingViewController.swift
//  Joggen
//
//  Created by Owen Prasetya on 15/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit
import CoreMotion

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // Take today's date to know which week we are in here! (For validation)
    /* HERE */
    //var week = weekHistory[0]
    
    // Taking model's data as a base for timer
    // **************
    var interval : [Int] = []
    var intervalType : [String] = []
    var counterInterval = 0
    
    var currActivity : String = ""
    
    var defJogInterval = 1
    var defWalkInterval = 1
    var defDuration = 10
    
    // MARK: - Goals
    var desiredDuration: Float = 0.0
    var desiredDistance: Float = 0.0
    
    var goals : [Target]?
    var goalThisWeek : Target?
    
    // Timer & Stopwatch
    var timer = Timer()
    var stopwatch = Timer()
    var counter = 0
    var runningTimer = Timer()
    var walkingTimer = Timer()
    var stopwatchCounter = 0
    var isTimerRunning = false
    var isRunningTimerRunning = false
    var isWalkingTimerRunning = false
    var isStopwatchRunning = false
    var isTimerFinished = false
    var isPaused = false
    var isSessionFinished = false
    ////////////////////////////////////////
    var tempSecond = 0.0
    var tempStopwatch = 0.0
    var tempCountdown = 0.0
    ////////////////////////////////////////
    var countdownSpace = CGRect()
    var countdownLabel = UILabel()
    
    
    // Creating circle for the Timer progress bar
    let shapeLayer = CAShapeLayer()
    
    //variable for sensor
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    //measurement
    var calories: Int32?
    var distance: Float?
    var duration: Int32?
    var id: Int16?
    var jog_interval: Int32 = 0
    var walk_interval: Int32 = 0
    var session_count: Int32?
    ///////////////////////////////////////
    //    var start_jog = DispatchTime.now()
    //    var start_walk = DispatchTime.now()
    //    var end_jog = DispatchTime.now()
    //    var end_walk = DispatchTime.now()
    var walk_timer = Timer()
    var jog_timer = Timer()
    var all_timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goals = DataHandler.retrieveTarget()
        
        if !goals!.isEmpty {
            for i in 0...goals!.count - 1 {
                if UserDefaults.standard.integer(forKey: "week") == goals![i].week!.id {
                    goalThisWeek = goals![i]
                    break
                }
            }
        }
        
        
        if goalThisWeek == nil {
            calculateInterval(duration: Int(defDuration), jogging: Int(defJogInterval), walk: Int(defWalkInterval))
        } else {
            calculateInterval(duration: Int(desiredDuration), jogging: Int(goalThisWeek!.jog_interval), walk: Int(goalThisWeek!.walk_interval))
        }
        
        // Deciding activity
        currActivity = intervalType[counterInterval]
        
        // Timer setup before start
        counter = interval[counterInterval] * 60
        
        let desiredGoalString = alterMinuteSeconds(counterNum: counter)
        
        let desiredMinuteString = desiredGoalString[0]
        let desiredSecondString = desiredGoalString[1]
        
        timerLabel.text = "\(desiredMinuteString):\(desiredSecondString)"
        timeSpentLabel.text = "00:00"
        
        //countdownTimer()
        startTimer()
        startStopwatch()
        buildUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMotionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        if currActivity == "Jogging" {
        //            start_jog = DispatchTime.now()
        //        }
        //        else if currActivity == "Walking" {
        //            start_walk = DispatchTime.now()
        //        }
        
        startActivity()
        
        startPedometer()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        stopButton.isEnabled = false
        
        if isTimerRunning {
            pauseTimer()
            pauseStopwatch()
            
            pauseButton.setTitle("Resume", for: .normal)
        }
        else {
            resumeAnimation()
            stopButton.isEnabled = true
            
            pauseButton.setTitle("Pause", for: .normal)
            startTimer()
            startStopwatch()
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        pauseTimer()
        pauseStopwatch()
        isPaused = false
        showStopAlert()
    }
    
    
}




