//
//  FacebookService.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import PromiseKit

class FacebookService: NSObject {
    
    class var sharedInstance: FacebookService {
        struct Static {
            static var instance: FacebookService?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FacebookService()
        }
        
        return Static.instance!
    }

    
    func getFriends() -> Promise<[MemberModel]>{
        return Promise{fulfill, reject in
            
            if let _ = FBSDKAccessToken.currentAccessToken() {
                let request = FBSDKGraphRequest(graphPath: "/me/friendlists", parameters: nil)
                
                request.startWithCompletionHandler({ res in
                    if let data = res.1 as? NSDictionary {
                        print(data)
                    }
                })
            }
        }
    }
    


}
