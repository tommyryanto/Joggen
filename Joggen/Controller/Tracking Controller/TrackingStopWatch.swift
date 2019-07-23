//
//  TrackingStopWatch.swift
//  Joggen
//
//  Created by Tommy Ryanto on 20/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

////////////////////////////////////// STOPWATCH /////////////////////////
extension TrackingViewController {
    
    ///////////////////////////////// STOPWATCH /////////////////////////////////
    func startStopwatch() {
        if !isStopwatchRunning {
            stopwatch = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(runStopwatch), userInfo: nil, repeats: true)
            isStopwatchRunning = true
            isPaused = false
        }
        
    }
    
    @objc func runStopwatch() {
        tempStopwatch += 0.05
        //print(tempSecond)
        
        
        if tempStopwatch >= 0.996 {
            stopwatchCounter += 1
            duration = Int32(stopwatchCounter)
            // MM::SS
            let flooredCounter = Int(floor(CGFloat(stopwatchCounter)))
            
            let currString = alterMinuteSeconds(counterNum: flooredCounter)
            
            let minuteString = currString[0]
            let secondString = currString[1]
            
            
            timeSpentLabel.text = "\(minuteString):\(secondString)"
            
            tempStopwatch = 0.0
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
        
        saveMotionData()
    }
}



//////////////////////////////////////// ALERT & UTILITY/////////////////////////
extension TrackingViewController {
    
    func showStopAlert() {
        let minutesLeft = timerLabel.text?.prefix(2)
        let secondsLeft = timerLabel.text?.suffix(2)
        
        var alertMsg = ""
        if counterInterval < interval.count-1 {
            alertMsg = "You still have \(interval.count - counterInterval - 1) sessions left to go"
        }
        else {
            if minutesLeft != "00" {
                alertMsg = "You still have \(minutesLeft!) minutes \(secondsLeft!) seconds left to go"
            }
            else if minutesLeft != "00" && secondsLeft == "00"{
                alertMsg = "You still have \(minutesLeft!) minutes left to go"
            }
            else {
                alertMsg = "You still have \(secondsLeft!) seconds left to go"
            }
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
    
    func calculateInterval(duration: Int, jogging: Int, walk: Int)
    {
        let cycle: Int = duration / (jogging + walk)
        
        for _ in 0...cycle
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
    
}
