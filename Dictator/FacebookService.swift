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

    private (set) var currentUser: MemberModel?
    private (set) var currentUserPhoto: UIImage?
    
    func getMeProfilePicture() -> Promise<UIImage> {
        return Promise{fulfill, reject in
            let requestPP = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["redirect":false])
            requestPP.startWithCompletionHandler({ res in
                if let data = res.1 as? NSDictionary {
                    if let imageUrl = data["data"]?["url"] as? String {
                        if let imgUrl = NSURL(string: imageUrl) {
                            if let data = NSData(contentsOfURL: imgUrl){
                                self.currentUserPhoto = UIImage(data: data)!
                                fulfill(self.currentUserPhoto!)
                            }
                        }
                    }
                }
            })
        }
    }

    func getMe() -> Promise<MemberModel>{
        return Promise{fulfill, reject in
            
            let request = FBSDKGraphRequest(graphPath: "/me", parameters: nil)
            request.startWithCompletionHandler({ res in
                if let data = res.1 as? NSDictionary {
                    if let fullName = data["name"] as? String {
                        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                        self.currentUser = MemberModel(firstName: fullNameArr[0], lastName: fullNameArr[1])
                        fulfill(self.currentUser!)
                    }
                }
            })
        }
        
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
