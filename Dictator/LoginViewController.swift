//
//  LoginViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/5/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import Neon

extension LoginViewController : FBSDKLoginButtonDelegate {

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if(error != nil) {
            DialogService.sharedInstance.showError(error.description, parent: self)
            return
        }
        
        if(result.isCancelled) {
            return
        }
    
        NSUserDefaults.standardUserDefaults().setValue(result.token.tokenString, forKey: "fbToken")
            
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("PartiesViewController")
        self.presentViewController(controller, animated: true, completion: nil)

        
    }
}

class LoginViewController: UIViewController {

    func skipBtnDidTap(sender: UIButton) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("PartiesViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        loginButton.anchorAndFillEdge(.Bottom, xPad: 10, yPad: 100, otherSize: 50)
        
        let skipBtn = UIButton()
        skipBtn.backgroundColor = UIColor.redColor()
        skipBtn.tintColor = UIColor.redColor()
        skipBtn.setTitle("Skip", forState: .Normal)
        skipBtn.addTarget(self, action: #selector(skipBtnDidTap), forControlEvents: .TouchUpInside)
        self.view.addSubview(skipBtn)
        skipBtn.anchorToEdge(.Bottom, padding: 40, width: 100, height: 30)
    }
}
