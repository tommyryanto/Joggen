//
//  TrackingUI.swift
//  Joggen
//
//  Created by Tommy Ryanto on 20/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

//////////////////////////////////////CONFIGURING UI/////////////////////////////
extension TrackingViewController {
    
    //    // Buat animasi di awal menandakan mau mulai jogging
    //    func countdownTimer() {
    //        var countdownTimer = Timer()
    //
    //        countdownSpace = CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.height)
    //        countdownLabel = UILabel(frame: countdownSpace)
    //
    //        countdownLabel.center = self.view.center
    //        countdownLabel.textAlignment = NSTextAlignment.center
    //
    //        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runCountdown), userInfo: nil, repeats: true)
    //
    //
    //        // Countdown dari 3 .. 2 .. 1
    //    }
    //
    //    @objc func runCountdown() {
    //        var countdown = 3
    //
    //        countdownLabel.text = "\(countdown)"
    //
    //        countdown -= 1
    //
    //        if countdown == 0 {
    //            countdownLabel.isHidden = true
    //        }
    //
    //    }

    ///////////////////////////////// CONFIGURE UI /////////////////////////////////

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
        
        animateBar(duration: Float(CGFloat(counter) * 1.26))
    }

    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }

    ///////////////////////////////// TIMER /////////////////////////////////
    func startTimer() {
        // MM::SS
        let flooredCounter = Int(floor(CGFloat(counter)))
        
        let currString = alterMinuteSeconds(counterNum: flooredCounter)
        
        let minuteString = currString[0]
        let secondString = currString[1]
        
        timerLabel.text = "\(minuteString):\(secondString)"
        
        if !isTimerRunning && isTimerFinished {
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            isPaused = false
            animateBar(duration: Float(CGFloat(counter) * 1.26))
            isTimerFinished = false
        }
        else {
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            isPaused = false
        }
    }

    func startRunningTimer() {
        if !isRunningTimerRunning {
            runningTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runRunningTimer), userInfo: nil, repeats: true)
            isRunningTimerRunning = true
        }
    }

    @objc func runRunningTimer() {
        jog_interval += 1
    }

    @objc func runWalkingTimer() {
        walk_interval += 1
    }

    func pauseWalkingTimer() {
        walkingTimer.invalidate()
        isWalkingTimerRunning = false
    }

    func pauseRunningTimer() {
        runningTimer.invalidate()
        isRunningTimerRunning = false
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
            
            // Checking whether the session has ended or not
            if counter == 0 && counterInterval < interval.count-1 {
                stopTimer()
                saveMotionData()
                counterInterval += 1
                isTimerFinished = true
                counter = interval[counterInterval] * 60
                currActivity = intervalType[counterInterval]
                stopButton.isEnabled = true
                pauseButton.isEnabled = true
                startTimer()
            }
            else if counter == 0 && counterInterval == interval.count-1 {
                stopTimer()
                stopStopwatch()
                isTimerFinished = true
                isSessionFinished = true
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

    func stopTimer() {
        if isTimerRunning {
            timer.invalidate()
        }
        
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        
        isTimerRunning = false

        saveMotionData()
    }
}

