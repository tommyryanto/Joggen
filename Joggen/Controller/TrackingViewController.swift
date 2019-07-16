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
    
    // MARK: - DUMMY
    
    var desiredDuration: Float = 0.0
    var desiredDistance: Float = 0.0
    
    
    // Taking model's data as a base for timer
    // **************
    
    // Timer
    var timer = Timer()
    var counter: Int = 0
    var isTimerRunning = false
    
    var tempSecond = 0.0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* INI DUMMY, NTAR PAKE MODEL YANG BENER */
        var desiredTarget = targetGoals[0]
        
        desiredDuration = desiredTarget.duration
        counter = Int(desiredDuration * 60)
        desiredDistance = desiredTarget.distance
        
        let desiredMinutes = counter / 60
        var desiredMinuteString = "\(desiredMinutes)"
        if desiredMinutes < 10 {
            desiredMinuteString = "0\(desiredMinutes)"
        }
        
        let desiredSeconds = counter % 60
        var desiredSecondString = "\(desiredSeconds)"
        if desiredSeconds < 10{
            desiredSecondString = "0\(desiredSeconds)"
        }
        
        timerLabel.text = "\(desiredMinuteString):\(desiredSecondString)"
        
        //countdownTimer()
        startTimer()
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startActivity()
        
        startPedometer()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        let mediaTime = CACurrentMediaTime()
        let pausedTime = CFTimeInterval(mediaTime)
        
        if isTimerRunning {
            timer.invalidate()
            
            let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            shapeLayer.speed = 0.0
            shapeLayer.timeOffset = pausedTime
            
            pauseButton.titleLabel?.text = "Resume"
            isTimerRunning = false
        }
        else {
            let pausedTime = shapeLayer.timeOffset
            shapeLayer.speed = 1.0
            shapeLayer.timeOffset = 0.0
            shapeLayer.beginTime = 0.0
            let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            shapeLayer.beginTime = timeSincePause
            
            pauseButton.titleLabel?.text = "Pause"
            startTimer()
            isTimerRunning = true
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        stopTimer()
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
        }
        
    }
    
    @objc func runTimer() {
        tempSecond += 0.05
        print(tempSecond)
        if tempSecond >= 1 {
            counter -= 1
            
            // MM::SS
            let flooredCounter = Int(floor(CGFloat(counter)))
            let minute = flooredCounter / 60
            var minuteString = "\(minute)"
            if minute < 10 {
                minuteString = "0\(minute)"
            }
            
            let seconds = flooredCounter % 60
            var secondString = "\(seconds)"
            if seconds < 10 {
                secondString = "0\(seconds)"
            }
            
            timerLabel.text = "\(minuteString):\(secondString)"
            
            tempSecond = 0.0
            
            if counter == 0 {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        
        isTimerRunning = false
    }
    
    
}
