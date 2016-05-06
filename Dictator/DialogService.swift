//
//  DialogService.swift
//  WhereWeLive
//
//  Created by Eran Kaufman on 9/30/15.
//  Copyright © 2015 Eran Kaufman. All rights reserved.
//

import UIKit
import Whisper


class DialogService {
    
    class var sharedInstance: DialogService {
        struct Static {
            static var instance: DialogService?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DialogService()
        }
        
        return Static.instance!
    }

    
    func showError(message: String, parent: UIViewController){
        
        let announcement = Murmur(title:message, backgroundColor: UIColor.redColor(), titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(12))
        Whistle(announcement)
        
        /*
         if let navController = parent.navigationController {
         let message = Message(title:message, textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor())
         Whisper(message, to: navController, action: .Show)
         } else {
         let announcement = Murmur(title:message, backgroundColor: UIColor.redColor(), titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(12), duration: 2)
         Whistle(announcement)
         }*/
    }
    
    func showSuccess(message: String, parent: UIViewController){
        
        let announcement = Murmur(title:message, backgroundColor: UIColor.greenColor(), titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(12))
        Whistle(announcement)
        
        /*
         if let navController = parent.navigationController {
         let message = Message(title:message, textColor: UIColor.greenColor())
         Whisper(message, to: navController, action: .Show)
         } else {
         
         let announcement = Murmur(title:message, backgroundColor: UIColor.greenColor(), titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(12))
         Whistle(announcement)
         }*/
    }
    

    
}
