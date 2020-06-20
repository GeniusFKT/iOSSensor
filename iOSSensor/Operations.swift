//
//  Operations.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/6/10.
//  Copyright © 2020 kenneth. All rights reserved.
//

import Foundation

class SensorOperation: Operation {
    var sensor: Sensor
    
    init(sensor: Sensor) {
        self.sensor = sensor
    }
    
    override func main() {
        print("hello")
    }
}
