//
//  GuideInterfaceController.swift
//  museumPrototype
//
//  Created by Dan Isacson on 09/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class GuideInterfaceController: WKInterfaceController {

    var isPlaying = false
    var hasInitiatedSong = false
    
    @IBOutlet var playPauseIndicatorImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        if(context != nil){
            self.play()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func initSong(){
        WKInterfaceController.openParentApplication(["mode":"initSong"], reply: { (reply, error) -> Void in
            println(reply)
        })
        self.hasInitiatedSong = true
    }
    
    func play(){
        if(!self.hasInitiatedSong){
            self.initSong()
        }
        
        WKInterfaceController.openParentApplication(["mode":"play"], reply: { (reply, error) -> Void in
            println(reply)
        })
        self.isPlaying = true
        self.playPauseIndicatorImage.setImage(UIImage(named: "pause"))
    }
    
    func stop(){
        WKInterfaceController.openParentApplication(["mode":"stop"], reply: { (reply, error) -> Void in
            println(reply)
        })
        self.isPlaying = false
        self.playPauseIndicatorImage.setImage(UIImage(named: "play"))

    }
    
    func pause(){
        WKInterfaceController.openParentApplication(["mode":"pause"], reply: { (reply, error) -> Void in
            println(reply)
        })
        self.isPlaying = false
        self.playPauseIndicatorImage.setImage(UIImage(named: "play"))
    }
    
    @IBAction func audioGuidePressed() {
        if(isPlaying){
            self.pause()
        }else{
            self.play()
        }
    }

}
