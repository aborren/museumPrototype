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

    var art: ArtObject!
    var isPlaying = false
    var hasInitiatedSong = false
    
    @IBOutlet var backgroundArtGroup: WKInterfaceGroup!
    @IBOutlet var playPauseIndicatorImage: WKInterfaceImage!
    
    @IBOutlet var artTitle: WKInterfaceLabel!
    @IBOutlet var createdLabel: WKInterfaceLabel!
    @IBOutlet var creatorLabel: WKInterfaceLabel!
    @IBOutlet var informationLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        let dict = context as! NSDictionary
        self.art = dict["art"] as! ArtObject
        
        self.backgroundArtGroup.setBackgroundImageNamed(self.art.imageName)
        self.artTitle.setText(self.art.title)
        self.createdLabel.setText(self.art.created)
        self.creatorLabel.setText(self.art.creator)
        self.informationLabel.setText(self.art.information)
        
        if(dict["play"] as! Bool){
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
        WKInterfaceController.openParentApplication(["mode":"initSong", "song":self.art.audioGuide!], reply: { (reply, error) -> Void in
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
