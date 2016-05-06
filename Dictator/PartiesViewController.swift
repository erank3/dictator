//
//  PartiesViewController.swift
//
//
//  Created by Eran Kaufman on 5/5/16.
//
//

import UIKit
import BubbleTransition
import Neon


extension PartiesViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = addPartyBtn.center
        transition.bubbleColor = addPartyBtn.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = addPartyBtn.center
        transition.bubbleColor = addPartyBtn.backgroundColor!
        return transition
    }
}

class PartiesViewController: UIViewController {
    
    private var addPartyBtn: UIButton!
    
    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    func thumbsUpButtonPressed() {
        self.performSegueWithIdentifier("addParty", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPartyBtn = UIButton(type: .Custom)
        addPartyBtn.backgroundColor = UIColor.whiteColor()
        addPartyBtn.frame = CGRectMake(0,0, 50, 50)
        addPartyBtn.layer.cornerRadius = 0.5 * addPartyBtn.bounds.size.width
        //button.setImage(UIImage(named:"thumbsUp.png"), forState: .Normal)
        addPartyBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), forControlEvents: .TouchUpInside)
        
        view.addSubview(addPartyBtn)
        
        addPartyBtn.anchorToEdge(.Bottom, padding: 50, width: 50, height: 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
