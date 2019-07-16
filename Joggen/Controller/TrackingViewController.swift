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
    
    // Creating a circle
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startActivity()
        startPedometer()
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
    }
}

extension TrackingViewController {
    func animateBar(duration: Int) {
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
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        backLayer.path = circularPath.cgPath
        
        backLayer.strokeColor = UIColor.lightGray.cgColor
        backLayer.lineWidth = 10
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.lineCap = CAShapeLayerLineCap.round
        
        // Create a path for it to draw itself
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.8745098039, green: 0.3921568627, blue: 0.09803921569, alpha: 1)
        shapeLayer.lineWidth = 16
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        // Where does the stroke end
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(backLayer)
        view.layer.addSublayer(shapeLayer)
        
        animateBar(duration: 60)
    }
}
