//
//  PlaceModel.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit

class PlaceModel: NSObject {
    var placeName: String!
    var googleId: String!
    var wwlId: String!
    var address: String!
    var latitude: Double!
    var longitude: Double!
    
    
    override init(){
        
    }
    
    init(name: String, googleId: String, address: String) {
        
        self.placeName = name
        self.googleId = googleId
        self.address = address
        
    }
    
    init(placeName: String) {
        self.placeName = placeName
    }
}

class GooglePlaceModel: PlaceModel {
    
    var phoneNumber = ""
    var website = ""
    var rating: Float!
    var openNow: Bool?
    var priceLevel: Int!
    
    init(name: String, googleId: String, address: String, website: String="", phoneNumber: String="", rating: Float=0, openNow: Bool?=nil, priceLevel: Int=0) {
        
        super.init(name: name, googleId: googleId, address: address)
        
        self.website = website
        self.phoneNumber = phoneNumber
        self.rating = rating
        self.openNow = openNow
        self.priceLevel = priceLevel
    }
    
}

