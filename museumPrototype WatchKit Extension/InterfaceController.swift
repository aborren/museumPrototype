//
//  InterfaceController.swift
//  museumPrototype WatchKit Extension
//
//  Created by Dan Isacson on 08/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var testBtn: WKInterfaceButton!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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

    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        let notification = JSON(remoteNotification)
        if let listen = identifier{
            if(listen == "firstButtonAction"){
                self.pushControllerWithName("Guide", context: true)
            }
        }
    }
    
    @IBAction func test() {
        pushControllerWithName("Guide", context: nil)
    }
}
