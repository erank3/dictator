//
//  MemberModel.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit

class MemberModel: NSObject {
    
    var firstName: String = ""
    var lastName: String = ""
    
    
    init(firstName: String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
