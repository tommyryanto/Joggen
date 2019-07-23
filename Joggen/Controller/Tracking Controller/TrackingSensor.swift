//
//  TrackingSensor.swift
//  Joggen
//
//  Created by Tommy Ryanto on 20/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit
import CoreMotion

//////////////////////////////////CONFIGURING TRACKING SENSOR//////////////////////////////
extension TrackingViewController {
    func startActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: OperationQueue.current!) { (activity) in
                if let data = activity {
                    DispatchQueue.main.async {
                        if data.running {
                            self.walk_timer.invalidate()
                            self.jog_timer = Timer(timeInterval: 1, target: self, selector: #selector(self.startJoggingTimer)
                                , userInfo: nil, repeats: true)
                            
                            //add timer to running
                        } else if data.walking || data.cycling || data.stationary || data.unknown {
                            self.jog_timer.invalidate()
                            self.walk_timer = Timer(timeInterval: 1, target: self, selector: #selector(self.startWalkingTimer)
                                , userInfo: nil, repeats: true)
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
                    self.distanceLabel.text = "\(self.distance!)"
                } else {
                    print((error?.localizedDescription)!)
                }
            }
        } else {
            print("pedometer not available")
        }
    }
    
    func saveMotionData() {
        
        // Id dapat darimana?
        // Calories belum ada rumusnya
        //
        ////////////////////// BREAKPOINT ////////////////////////////////////////////////////
        
        if duration == nil { duration = 0 }
        if distance == nil { distance = 0 }
        session_count = Int32(interval.count)
        
        
        DataHandler.saveAchived(calories: 0, duration: duration!, id: Int16(UserDefaults.standard.integer(forKey: "week")), jog_interval: jog_interval, walk_interval: walk_interval, distance: distance!, session_count: session_count! + 1, date_start: Date())
    }
    
    @objc func startJoggingTimer() {
        jog_interval += Int32(1)
        print(jog_interval)
    }
    
    @objc func startWalkingTimer() {
        walk_interval += Int32(1)
        print(walk_interval)
    }
    
}
