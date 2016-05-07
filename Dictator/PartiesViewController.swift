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
import SAParallaxViewControllerSwift



extension PartiesViewController {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EntitiesService.sharedInstance.getParties().count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let parties = EntitiesService.sharedInstance.getParties()
        
        if let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? SAParallaxViewCell {
            cell.backgroundColor = UIColor.greenColor()
            let imageName = "food"
            if let image = UIImage(named: imageName) {
                cell.setImage(image)
            }
            let label = UILabel(frame: cell.containerView.accessoryView.bounds)
            label.textAlignment = .Center
            label.text = parties[indexPath.row].name
            label.textColor = .whiteColor()
            label.font = .systemFontOfSize(30)
            cell.containerView.accessoryView.addSubview(label)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension PartiesViewController {
    override func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = presented as? UINavigationController {
            transition.transitionMode = .Present
            transition.startingPoint = addPartyBtn.center
            transition.bubbleColor = addPartyBtn.backgroundColor!
            return transition
        }
        return super.animationControllerForPresentedController(presented, presentingController: presenting, sourceController: source)
    }
    
    override func animationControllerForDismissedController(dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = addPartyBtn.center
        transition.bubbleColor = addPartyBtn.backgroundColor!
            
        self.collectionView.reloadData()
            
        return transition
    }
}

class PartiesViewController: SAParallaxViewController {
    
    private var addPartyBtn: UIButton!
    private let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    func thumbsUpButtonPressed() {
        self.performSegueWithIdentifier("addParty", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        print(EntitiesService.sharedInstance.getParties())
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPartyBtn = UIButton(type: .Custom)
        addPartyBtn.backgroundColor = UIColor.redColor()
        addPartyBtn.frame = CGRectMake(0,0, 50, 50)
        addPartyBtn.layer.cornerRadius = 0.5 * addPartyBtn.bounds.size.width
        addPartyBtn.setTitle("+", forState: .Normal)
        
        addPartyBtn.titleLabel!.textColor = UIColor.blueColor()
        addPartyBtn.titleLabel!.font = UIFont.systemFontOfSize(20)
        
        addPartyBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), forControlEvents: .TouchUpInside)
        
        view.addSubview(addPartyBtn)
        
        addPartyBtn.anchorInCorner(.BottomRight, xPad: 30, yPad: 50, width: 50, height: 50)
    }
}
