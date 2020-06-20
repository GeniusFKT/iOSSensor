//
//  ContentView.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/27.
//  Copyright © 2020 kenneth. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject var sensor : Sensor

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header:Text("Sensors")){
                        Toggle(isOn: $sensor.useAccelerometers) {
                            Text("Accelerometers")
                        }
                        
                        Toggle(isOn: $sensor.useAttitude){
                            Text("Attitude")
                        }
                        
                        Toggle(isOn: $sensor.useGyroscopes) {
                            Text("Gyroscopes")
                        }
                        
                        Toggle(isOn: $sensor.useMagnetometer) {
                            Text("Magnetometer")
                        }
                        
                        Toggle(isOn: $sensor.useGravity) {
                            Text("Gravity")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .frame(height: 240)

                VStack {
                    Text("Enter sampling frequency(Hz) below: ")
                        
                    TextField("", text: $sensor.f).frame(width: 100.0, height: 40.0).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    HStack {
                        Button(action: sensor.startFGSensoring) {
                            Text("Start")
                            }.padding(.trailing)
                            .alert(isPresented: $sensor.showingAlert) {
                            Alert(title: Text("Invalid Input!"),
                                  message: Text("Please type in a valid number"),
                                  dismissButton: .default(Text("OK")))
                        }
                        
                        Button(action: sensor.stopSensoring) {
                            Text("Stop")
                        }
                    }.padding(.top)
                }
                .padding(.bottom)

                ScrollView(.horizontal) {
                    HStack (spacing: 200){
                        VStack {
                            Text("Attitude").font(.title).bold()
                            Spacer()
                            Text("pitch: \(sensor.pitch)")
                            Text("roll: \(sensor.roll)")
                            Text("yaw: \(sensor.yaw)")
                        }.position(x: 190, y: 60)
                        
                        VStack {
                            Text("Accelerometers").font(.title).bold()
                            Spacer()
                            Text("x: \(sensor.x)")
                            Text("y: \(sensor.y)")
                            Text("z: \(sensor.z)")
                        }
                        
                        VStack {
                            Text("Gyroscopes").font(.title).bold()
                            Spacer()
                            Text("rotate_x: \(sensor.rotate_x)")
                            Text("rotate_y: \(sensor.rotate_y)")
                            Text("rotate_z: \(sensor.rotate_z)")
                        }
                        
                        VStack {
                            Text("Magnetometer").font(.title).bold()
                            Spacer()
                            Text("magnetic_field_x: \(sensor.magnetic_field_x)")
                            Text("magnetic_field_y: \(sensor.magnetic_field_y)")
                            Text("magnetic_field_z: \(sensor.magnetic_field_z)")
                            Text("magnetic_field_acc: \(sensor.magnetic_field_acc)")
                        }
                        
                        VStack {
                            Text("Gravity").font(.title).bold()
                            Spacer()
                            Text("gravity_x: \(sensor.gravity_x)")
                            Text("gravity_y: \(sensor.gravity_y)")
                            Text("gravity_z: \(sensor.gravity_z)")
                        }
                    }
                }.frame(height: 120)
            }.navigationBarTitle("iOS Sensor Recoder",displayMode: .inline)        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(sensor)
    }
}
