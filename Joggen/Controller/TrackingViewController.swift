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
    
    // MARK: - Goals
    var desiredDuration: Float = 0.0
    var desiredDistance: Float = 0.0
    
    // Timer & Stopwatch
    var timer = Timer()
    var stopwatch = Timer()
    var counter: Int = 0
    var stopwatchCounter = 0
    var isTimerRunning = false
    var isStopwatchRunning = false
    var isPaused = false
    ////////////////////////////////////////
    var tempSecond = 0.0
    var tempStopwatch = 0.0
    
    
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
    var jog_interval: Int32?
    var walk_interval: Int32?
    var session_count: Int32?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //saveMotionData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saveDummyData()
        /* INI DUMMY, NTAR PAKE MODEL YANG BENER */
        var desiredTarget = targetGoals[0]
        
        desiredDuration = desiredTarget.duration
        desiredDistance = desiredTarget.distance
        
        // Time counter for timer
        counter = Int(desiredDuration * 60)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

extension TrackingViewController {
    func startActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.current!) { (activity) in
                if let data = activity {
                    DispatchQueue.main.async {
                        if data.running {
                            //add timer to running
                        } else if data.walking {
                            //add timer to walking
                        }
                    }
                } else {
                    print("error")
                }
            }
        } else {
            print("Motion not available")
        }
    }
    
    func startPedometer() {
        if CMPedometer.isPedometerEventTrackingAvailable() {
            pedometer.startUpdates(from: Date()) { (pedometerData, error) in
                if let data = pedometerData {
                    print(data.numberOfSteps)
                    self.distance = data.distance?.floatValue
                } else {
                    print((error?.localizedDescription)!)
                }
            }
        } else {
            print("pedometer not available")
        }
    }
    
    func saveMotionData() {
        DataHandler.saveAchived(calories: calories!, duration: duration!, id: id!, jog_interval: jog_interval!, walk_interval: walk_interval!, distance: distance!, session_count: session_count!, date_start: Date())
    }
}

extension TrackingViewController {
    
    // Buat animasi di awal menandakan mau mulai jogging
    func countdownTimer() {
        var countdown = 3
        
        let countdownSpace = CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.height)
        let countdownLabel = UILabel(frame: countdownSpace)
        
        countdownLabel.center = self.view.center
        countdownLabel.textAlignment = NSTextAlignment.center
        
        // Countdown dari 3 .. 2 .. 1
    }
    
    func animateBar(duration: Float) {
        // Creating animation for the progress bar stroke to move
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        // Set how long the animation should go on for
        basicAnimation.duration = CFTimeInterval(duration)
        
        // Make sure the animation stays on the screen
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basicStrokeAnimation")
    }
    
    func buildUI() {
        let center = view.center
        
        // Create a transparent background for the progress
        let backLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: self.view.frame.width/3, startAngle: -CGFloat.pi / 2 + 0.02, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        backLayer.path = circularPath.cgPath
        
        backLayer.strokeColor = UIColor.lightGray.cgColor
        backLayer.lineWidth = 8
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.lineCap = CAShapeLayerLineCap.round
        
        // Create a path for it to draw itself
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.8745098039, green: 0.3921568627, blue: 0.09803921569, alpha: 1)
        shapeLayer.lineWidth = 14
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        // Where does the stroke end
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(backLayer)
        view.layer.addSublayer(shapeLayer)
        
        animateBar(duration: Float(CGFloat(counter) * 1.27))
    }
    
    func startTimer() {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            isPaused = false
        }
        
    }
    
    @objc func runTimer() {
        tempSecond += 0.05
        //print(tempSecond)
        
        if tempSecond >= 0.996 && isTimerRunning {
            counter -= 1
            
            // MM::SS
            let flooredCounter = Int(floor(CGFloat(counter)))
            
            let currString = alterMinuteSeconds(counterNum: flooredCounter)
            
            let minuteString = currString[0]
            let secondString = currString[1]
            
            timerLabel.text = "\(minuteString):\(secondString)"
            
            tempSecond = 0.0
            
            if counter == 0 {
                stopTimer()
            }
        }
    }
    
    func pauseTimer() {
        timer.invalidate()
        isPaused = true
        
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
        
        isTimerRunning = false
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    func stopTimer() {
        if isTimerRunning {
            timer.invalidate()
            stopwatch.invalidate()
        }
        
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        
        isTimerRunning = false
    }
}

// STOPWATCH & DISTANCE
extension TrackingViewController {
    func startStopwatch() {
        if !isStopwatchRunning {
            print("A")
            stopwatch = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(runStopwatch), userInfo: nil, repeats: true)
            isTimerRunning = true
            isPaused = false
        }
        
    }
    
    @objc func runStopwatch() {
        tempStopwatch += 0.05
        //print(tempSecond)
        
        if tempStopwatch >= 0.996 {
            stopwatchCounter += 1
            
            // MM::SS
            let flooredCounter = Int(floor(CGFloat(stopwatchCounter)))
            
            let currString = alterMinuteSeconds(counterNum: flooredCounter)
            
            let minuteString = currString[0]
            let secondString = currString[1]
            
            
            timeSpentLabel.text = "\(minuteString):\(secondString)"
            
            tempStopwatch = 0.0
            
            if stopwatchCounter == 0 {
                stopStopwatch()
            }
        }
    }
    
    func pauseStopwatch() {
        stopwatch.invalidate()
        isPaused = true
    }
    
    func stopStopwatch() {
        
        if isStopwatchRunning {
            stopwatch.invalidate()
        }
        
        isStopwatchRunning = false
    }
}



// ALERT & UTILITY
extension TrackingViewController {
    
    func showStopAlert() {
        let minutesLeft = timerLabel.text?.prefix(2)
        let secondsLeft = timerLabel.text?.suffix(2)
        
        var alertMsg = ""
        if minutesLeft != "00" {
            alertMsg = "You still have \(minutesLeft!) minutes \(secondsLeft!) seconds left to go"
        }
        else if minutesLeft != "00" && secondsLeft == "00"{
            alertMsg = "You still have \(minutesLeft!) minutes left to go"
        }
        else {
            alertMsg = "You still have \(secondsLeft!) seconds left to go"
        }
        
        let stopAlert = UIAlertController(title: "Are you sure you want to stop?", message: alertMsg, preferredStyle: .alert)
        
        
        stopAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.resumeAnimation()
            self.stopTimer()
            self.stopStopwatch()
            self.animateBar(duration: 0.75)
        }))
        
        stopAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            if !self.isPaused {
                self.startTimer()
                self.startStopwatch()
                self.resumeAnimation()
            }
        }))
        
        self.present(stopAlert, animated: true)
    }
    
    func alterMinuteSeconds(counterNum: Int) -> [String] {
        
        let totalMinutes = counterNum / 60
        var totalMinuteString = "\(totalMinutes)"
        if totalMinutes < 10 {
            totalMinuteString = "0\(totalMinutes)"
        }
        
        let totalSeconds = counterNum % 60
        var totalSecondString = "\(totalSeconds)"
        if totalSeconds < 10{
            totalSecondString = "0\(totalSeconds)"
        }
        
        return [totalMinuteString, totalSecondString]
    }
    
}
