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
    
    @IBOutlet var artTable: WKInterfaceTable!
    var art: [ArtObject] = []
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.art = []
        self.createArt()
        self.setUpArtRows()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        let notification = JSON(remoteNotification)
        if let listen = identifier{
            if(listen == "play"){
                 //return ["art" : self.art[rowIndex], "play" : true]
                self.createArt()
                self.pushControllerWithName("Guide", context: ["art":self.art[1], "play":true])
            }
        }
    }
    
    override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        let notification = JSON(localNotification)
        if let listen = identifier{
            if(listen == "play"){
                //return ["art" : self.art[rowIndex], "play" : true]
                self.createArt()
                if (localNotification.alertBody == "monalisa"){
                    self.pushControllerWithName("Guide", context: ["art":self.art[1], "play":true])
                }else if (localNotification.alertBody == "whistlersmother" ){
                    self.pushControllerWithName("Guide", context: ["art":self.art[0], "play":true])
                }
            }
        }
    }

    func setUpArtRows(){
        self.artTable.setNumberOfRows(self.art.count, withRowType: "artRow")
        for(var i = 0; i < self.art.count; i++){
            var row: ArtRow = self.artTable.rowControllerAtIndex(i) as! ArtRow
            row.artTitle.setText(self.art[i].title)
            row.group.setBackgroundImageNamed(self.art[i].imageName)
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return ["art" : self.art[rowIndex], "play" : false]
    }
    
    func createArt(){
        let art1 = ArtObject(id: "1", title: "Whistler's Mother", imageName: "whistlersmother", audioGuide: "whistlersmother", creator: "James McNeill Whistler", created: "1871", information: "Whistler painted his mother, Anna McNeill Whistler, when the original model failed to come to the appointment. The painting was not well-received when he submitted it to the Royal Academy of Art in London for exhibition, but shortly later the public showed much respect and deference for it, quickly restoring Whistler’s honor." )
        self.art.append(art1)
        let art2 = ArtObject(id: "2", title: "Mona Lisa", imageName: "monalisa", audioGuide: "monalisa", creator: "Leonardo da Vinci", created: "c. 1503-1519", information: "This painting depicts Lisa del Giocondo whose expression is well-known for the enigmatic aura emanating from it. The Mona Lisa is possibly the most famous painting in the world of all time.")
        self.art.append(art2)
        let art3 = ArtObject(id: "3", title: "Girl with a Pearl Earring", imageName: "pearlearing", audioGuide: "pearlearing", creator: "Johannes Vermeer", created: "1665", information: "One of Vermeer’s masterpieces, this painting utilizes a pearl earring as a focal point. It is sometimes known as “the Dutch Mona Lisa” or “the Mona Lisa of the North.”")
        self.art.append(art3)
    }
}
