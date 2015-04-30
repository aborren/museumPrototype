//
//  ArtObject.swift
//  museumPrototype
//
//  Created by Dan Isacson on 13/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class ArtObject {
    let id: String
    let title: String
    let imageName: String
    let audioGuide: String?
    let creator: String
    let created: String
    let information: String
    
    init(){
        self.id = ""
        self.title = ""
        self.imageName = ""
        self.audioGuide = nil
        self.creator = ""
        self.created = ""
        self.information = ""
    }
    
    init(id: String, title: String, imageName: String, audioGuide: String?, creator: String, created: String, information: String){
        self.id = id
        self.title = title
        self.imageName = imageName
        self.audioGuide = audioGuide
        self.creator = creator
        self.created = created
        self.information = information
    }
    
}