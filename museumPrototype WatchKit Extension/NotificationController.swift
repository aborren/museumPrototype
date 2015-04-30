//
//  NotificationController.swift
//  museumPrototype WatchKit Extension
//
//  Created by Dan Isacson on 08/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var artLabel: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        let notification = JSON(localNotification)
        let title: String = localNotification.alertBody!//notification["aps"]["alert"]["title"].description
        self.setArtBackground("monalisa.jpeg")
        self.setArtTitle(title)
        completionHandler(.Custom)
    }
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        let notification = JSON(remoteNotification)
        
        println(notification["aps"]["alert"]["title"])
        let title: String = notification["aps"]["alert"]["title"].description
        self.setArtBackground("monalisa.jpeg")
        self.setArtTitle(title)
        completionHandler(.Custom)
    }
    
    func setArtBackground(imageName: String){
        self.group.setBackgroundImage(UIImage(named: imageName))
    }
    
    func setArtTitle(title: String){
        self.artLabel.setText(title)
    }
}