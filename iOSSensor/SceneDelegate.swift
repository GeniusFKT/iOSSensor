//
//  SceneDelegate.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/25.
//  Copyright © 2020 kenneth. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

// var timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    var bg: UIBackgroundTaskIdentifier = .invalid
    var activity = ProcessInfo.processInfo.beginActivity(options: .latencyCritical, reason: "Hi")
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.requestAlwaysAuthorization()
        
        self.startMySignificantLocationChanges()
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        locationManager.startUpdatingLocation()

    }
    
    func startTimer() {
        sensor.startBGSensoring()
    }
    
    func startBGTask() {
        let application = UIApplication.shared
        self.bg = application.beginBackgroundTask(withName: "hello") {
            print(application.backgroundTimeRemaining)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
       // Do something with the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
          // Location updates are not authorized.
            manager.stopMonitoringSignificantLocationChanges()
            locationManager.delegate = nil
            return
       }
       // Notify the user of any errors.
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(sensor)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        self.initLocationManager()
        ProcessInfo.processInfo.endActivity(self.activity)
        print("App Initialize")
        print(ProcessInfo.processInfo.processIdentifier)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("Scene did become active")
        print(ProcessInfo.processInfo.processIdentifier)
        sensor.startFGSensoringFromBG()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("Scene resign actives")
        print(ProcessInfo.processInfo.processIdentifier)
        sensor.FGtimer.invalidate()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("Scene will enter foreground")
        print(ProcessInfo.processInfo.processIdentifier)
        
        // since this method called when app initializes
        // we should add an if condition
        if sensor.preventStartTwice {
            sensor.BGtimer.invalidate()
            
            let application = UIApplication.shared
            application.endBackgroundTask(self.bg)
            
            ProcessInfo.processInfo.endActivity(self.activity)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("Scene did enter background")
        print(ProcessInfo.processInfo.processIdentifier)
        if sensor.preventStartTwice {
            self.activity = ProcessInfo.processInfo.beginActivity(options: .latencyCritical, reason: "Hi")
            startTimer()
            startBGTask()
        }
    }
}


struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
