//
//  Sensor.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/26.
//  Copyright © 2020 kenneth. All rights reserved.
//

import Foundation
import CoreMotion

let s = Sensor()
var x = 0.0
var y = 0.0
var z = 0.0
var test = 0

class Sensor {
    let motionManager = CMMotionManager()
    
    func startDeviceMotion() {
        if self.motionManager.isDeviceMotionAvailable {
            test = 1
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            let timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motionManager.deviceMotion {
                                    // Get the attitude relative to the magnetic north reference frame.
                                    x = data.attitude.pitch
                                    y = data.attitude.roll
                                    z = data.attitude.yaw
                                    
                                    // Use the motion data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
        else {
            test = 2
        }
    }
}
