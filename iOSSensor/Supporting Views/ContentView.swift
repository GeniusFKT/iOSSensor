//
//  ContentView.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/25.
//  Copyright © 2020 kenneth. All rights reserved.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    var sensor: Sensor
    
    var body: some View {
        VStack {
            Text("\(x)")
            Text("\(y)")
            Text("\(z)")
            Text("\(test)")
            
            HStack {
                Button(action: sensor.startDeviceMotion) {
                Text("Start")
                }
                .padding(.trailing)
                
                Button(action: sensor.motionManager.stopDeviceMotionUpdates) {
                Text("Stop")
                }
            }
            .padding(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sensor: s)
    }
}
