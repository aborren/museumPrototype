//
//  AppDelegate.swift
//  museumPrototype
//
//  Created by Dan Isacson on 08/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var hasTriggerediPhone = false
    var hasTriggerediPad = false
    
    
    let locationManager = CLLocationManager()
    var region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"), identifier: "Beacons")
    
    var inBackground = false
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.registerSettingsAndCategories() //for notificaition
        //application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert|UIUserNotificationType.Sound|UIUserNotificationType.Badge, categories: nil))
        
        application.applicationIconBadgeNumber = 0
        
        self.setupLocationManager()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.inBackground = true
        self.extendBackgroundRunningTime()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.inBackground = false
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println(notification.alertBody)
    }
    
    func setupLocationManager(){
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways){
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.locationManager.delegate = self
        self.region.notifyEntryStateOnDisplay = true
        self.region.notifyOnEntry = true
        self.region.notifyOnExit = true
        self.locationManager.startMonitoringForRegion(self.region)
    }
    
    
    func extendBackgroundRunningTime(){
        if(self.backgroundTask != UIBackgroundTaskInvalid){
            return
        }
        println("extending bg time")
        var self_terminate = true
        self.backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithName("Ranging", expirationHandler: { () -> Void in
            println("bg task expired by ios")
            if (self_terminate) {
                UIApplication.sharedApplication().endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            }
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            println("task started")
            /*while (true) {
            println("time remaining: \(UIApplication.sharedApplication().backgroundTimeRemaining)")
            NSThread.sleepForTimeInterval(1)
            }*/
            self.locationManager.startMonitoringForRegion(self.region)
        }
    }
    
    //LOCATION
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        
        if(state == CLRegionState.Inside){
            println("inside")
            self.locationManager.startRangingBeaconsInRegion(self.region)
        }else{
            println("outside")
            self.locationManager.stopMonitoringForRegion(self.region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as! CLBeacon
            for beacon in knownBeacons {
                if(beacon.minor == 123){
                    if(beacon.proximity.rawValue == 1){
                        if(!self.hasTriggerediPhone){
                            self.hasTriggerediPhone = true
                            self.triggerNotification("Mona Lisa")
                        }
                    }
                    println("iPhone \(beacon.accuracy) \(beacon.proximity.rawValue)")
                }
                else if(beacon.minor == 234){
                    if(beacon.proximity.rawValue == 1){
                        self.triggerNotification("pad")
                    }
                    println("iPad \(beacon.accuracy) \(beacon.proximity.rawValue)")
                }
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("hi")
        self.triggerNotification("Entered region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("bye")
        self.triggerNotification("Left region")
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("funkar detta?")
    }
    
    func triggerNotification(text: String){
        var notification:UILocalNotification = UILocalNotification()
        notification.alertTitle = "Nära"
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.applicationIconBadgeNumber = 1
        notification.category = "myCategory"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func registerSettingsAndCategories() {
        var categories = NSMutableSet()
        
        var acceptAction = UIMutableUserNotificationAction()
        acceptAction.title = NSLocalizedString("Audio guide", comment: "Listen to audioguide")
        acceptAction.identifier = "play"
        acceptAction.activationMode = UIUserNotificationActivationMode.Foreground
        acceptAction.authenticationRequired = false
        /*
        var declineAction = UIMutableUserNotificationAction()
        declineAction.title = NSLocalizedString("Decline", comment: "Decline invitation")
        declineAction.identifier = "decline"
        declineAction.activationMode = UIUserNotificationActivationMode.Background
        declineAction.authenticationRequired = false
        */
        var inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.setActions([acceptAction],
            forContext: UIUserNotificationActionContext.Default)
        inviteCategory.identifier = "myCategory"
        
        categories.addObject(inviteCategory)
        
        // Configure other actions and categories and add them to the set...
        
        var settings = UIUserNotificationSettings(forTypes: (.Alert | .Badge | .Sound), categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    //PLAYBACK
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        let info = JSON(userInfo!)
        if let mode = info["mode"].string  {
            if(mode == "play"){
                self.audioPlayer.play()
                reply(["reply":"play"])
            }else if(mode == "stop"){
                self.audioPlayer.stop()
                reply(["reply":"stop"])
            }else if(mode == "pause"){
                self.audioPlayer.pause()
                reply(["reply":"pause"])
            }else if(mode == "initSong"){
                self.initSong("hero") //with arg!
                reply(["reply":"init"])
            }
        }
    }

    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        return true
    }
    
    func initSong(song: String){
        //Enables Background playback
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(true, error: nil)
        
        var soundFilePath = NSBundle.mainBundle().pathForResource(song, ofType: "mp3")
        var fileURL = NSURL(string: soundFilePath!)
        self.audioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        self.audioPlayer.numberOfLoops = 1
        
    }
}

