//
//  Sensor.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/26.
//  Copyright © 2020 kenneth. All rights reserved.
//

import Foundation
import CoreMotion

let sensor = Sensor()

class Sensor: ObservableObject {
    let motionManager = CMMotionManager()
    let fileManager = FileManager.default
    
    @Published var pitch = 0.0
    @Published var roll = 0.0
    @Published var yaw = 0.0
    @Published var x = 0.0
    @Published var y = 0.0
    @Published var z = 0.0
    @Published var rotate_x = 0.0
    @Published var rotate_y = 0.0
    @Published var rotate_z = 0.0
    @Published var gravity_x = 0.0
    @Published var gravity_y = 0.0
    @Published var gravity_z = 0.0
    @Published var magnetic_field_x = 0.0
    @Published var magnetic_field_y = 0.0
    @Published var magnetic_field_z = 0.0
    @Published var magnetic_field_acc = 0
    @Published var f = "60"
    @Published var showingAlert = false
    
    @Published var useAccelerometers = true
    @Published var useAttitude = true
    @Published var useGyroscopes = true
    @Published var useGravity = true
    @Published var useMagnetometer = true
    
    var timer = Timer()
    
    var preventStartTwice = false
    
    // return the header string in the document
    func _getHeaderString() -> String {
        var s = ""
        // first line: sampling frequency
        s += "Sampling frequency: \(self.f)Hz \n"
        
        // get timestamp
        s += "timestamp "
        
        if self.useAccelerometers {
            s += "x y z "
        }
        
        if self.useAttitude {
            s += "pitch roll yaw "
        }
        
        if self.useGyroscopes {
            s += "rotate_x rotate_y rotate_z "
        }
        
        if self.useMagnetometer {
            s += "magnetic_field_x magnetic_field_y magnetic_field_z magnetic_field_acc "
        }
        
        if self.useGravity {
            s += "gravity_x gravity_y gravity_z "
        }
        
        s += "\n"
        return s
    }
    
    func startSensoring() {
        if !self.preventStartTwice {
            self.preventStartTwice = true
            
            // check frequency
            guard let f = Double(f) else {
                self.showingAlert = true
                return
            }
            
            // get document url
            let urlForDocument = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let url = urlForDocument[0] as URL
            
            // get current time (for document name)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY_MM_dd_HH_mm_ss"
            let date = dateformatter.string(from: Date())
            
            // calculate file url
            let file = url.appendingPathComponent("\(date).txt")
            // check
            let exist = self.fileManager.fileExists(atPath: file.path)
            // create file
            if !exist {
                self.fileManager.createFile(atPath: file.path, contents: nil, attributes: nil)
                
                let fileHandler = try! FileHandle(forWritingTo: file)
                fileHandler.seekToEndOfFile()
                let header = self._getHeaderString()
                let headerData = header.data(using: String.Encoding.utf8, allowLossyConversion: true)
                
                fileHandler.write(headerData!)
                
                // start sensoring
                self.startDeviceMotion(frequency: f, fileHandler: fileHandler)
            }
        }
    }
    
    func startDeviceMotion(frequency: Double, fileHandler: FileHandle) {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / frequency
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0 / frequency), repeats: true, block: { (timer) in
                    if let data = self.motionManager.deviceMotion {
                        // get current timestamp
                        let timeStamp = CLongLong(round(NSDate().timeIntervalSince1970 * 1000))
                        // current string
                        var current = "\(timeStamp) "
                        
                        if self.useAccelerometers {
                            self.x = data.userAcceleration.x
                            self.y = data.userAcceleration.y
                            self.z = data.userAcceleration.z
                            current += "\(self.x) \(self.y) \(self.z) "
                        }
                        
                        if self.useAttitude {
                            self.pitch = data.attitude.pitch
                            self.roll = data.attitude.roll
                            self.yaw = data.attitude.yaw
                            current += "\(self.pitch) \(self.roll) \(self.yaw) "
                        }
                        
                        if self.useGyroscopes {
                            self.rotate_x = data.rotationRate.x
                            self.rotate_y = data.rotationRate.y
                            self.rotate_z = data.rotationRate.z
                            current += "\(self.rotate_x) \(self.rotate_y) \(self.rotate_z) "
                        }
                        
                        if self.useMagnetometer {
                            self.magnetic_field_x = data.magneticField.field.x
                            self.magnetic_field_y = data.magneticField.field.y
                            self.magnetic_field_z = data.magneticField.field.z
                            self.magnetic_field_acc = Int(data.magneticField.accuracy.rawValue)
                            current += "\(self.magnetic_field_x) \(self.magnetic_field_y) \(self.magnetic_field_z) \(self.magnetic_field_acc) "
                        }
                        
                        if self.useGravity {
                            self.gravity_x = data.gravity.x
                            self.gravity_y = data.gravity.y
                            self.gravity_z = data.gravity.z
                            current += "\(self.gravity_x) \(self.gravity_y) \(self.gravity_z) "
                        }
                        
                        current += "\n"
                        let currentData = current.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        
                        fileHandler.write(currentData!)
                    }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func stopSensoring() {
        self.timer.invalidate()
        self.motionManager.stopDeviceMotionUpdates()
        self.pitch = 0
        self.roll = 0
        self.yaw = 0
        self.x = 0
        self.y = 0
        self.z = 0
        self.rotate_x = 0
        self.rotate_y = 0
        self.rotate_z = 0
        self.gravity_x = 0.0
        self.gravity_y = 0.0
        self.gravity_z = 0.0
        self.magnetic_field_x = 0.0
        self.magnetic_field_y = 0.0
        self.magnetic_field_z = 0.0
        self.magnetic_field_acc = 0
        self.preventStartTwice = false
    }
}
