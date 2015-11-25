//
//  trackingManager.swift
//  testmap
//
//  Created by Haoqian Zhang on 24/11/15.
//  Copyright © 2015 Haoqian Zhang. All rights reserved.
//

import Foundation
import CoreLocation

class trackingManager : NSObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    var seenError : Bool = false
    var mode : Int = 0
    var intervalTimer : NSTimer = NSTimer()
    var intervalNum : Int = 1
    
    func initTracking() {
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
    }
    
    func anytimeMode()
    {
        mode=0
    }
    
    func significantMode()
    {
        mode=1
    }
    
    func intervalMode(intervalTime:Int32)
    {
        intervalNum=Int(intervalTime)
        print(intervalNum)
        mode=2
    }
    
    func startTracking()
    {
        if mode==0
        {
            manager.stopMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
            stopIntervalTimer()
        }
        if mode==1
        {
            manager.stopUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            stopIntervalTimer()
        }
        if mode==2
        {
            manager.stopMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
            startIntervalTimer()
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        print("\(locations[0])")
        
        if mode==2
        {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        stopTracking()
        print(error)
    }
    
    func stopTracking()
    {
        manager.stopMonitoringSignificantLocationChanges()
        manager.stopUpdatingLocation()
        stopIntervalTimer()
    }
    
    func handleTimer(timer: NSTimer) {
        manager.stopMonitoringSignificantLocationChanges()
        manager.startUpdatingLocation()
    }
    
    func startIntervalTimer(){
        let doubleVar : Double = Double(intervalNum)
        let theTimeInterval : NSTimeInterval = doubleVar*60
        print(theTimeInterval)
        intervalTimer = NSTimer.scheduledTimerWithTimeInterval(theTimeInterval, target: self, selector: Selector("handleTimer:"), userInfo: nil, repeats: true)
    }
    
    func stopIntervalTimer(){
        intervalTimer.invalidate()
    }
}