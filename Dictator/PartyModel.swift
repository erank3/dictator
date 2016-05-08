//
//  PartyModel.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import CoreData

class PartyModel: NSObject {
    var id: Int = 0
    var name: String = "New Party"
    var members: [MemberModel] = []
    
    override init() {
        
    }
    
    init(name: String) {
        self.name = name
    }
    init(id:Int, name: String) {
        self.id = id
        self.name = name
    }
}
