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
import FontAwesome_swift


extension PartiesViewController {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EntitiesService.sharedInstance.getParties().count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let parties = EntitiesService.sharedInstance.getParties()
        
        if let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as?
            SAParallaxViewCell {
            
            let partyModel = parties[indexPath.row]
            for view in cell.containerView.accessoryView.subviews {
                if let view = view as? UILabel {
                    view.removeFromSuperview()
                }
            }
            
            let imageName = partyModel.category
            if let image = UIImage(named: imageName) {
                
                cell.setImage(image)
            }
            
            let label = UILabel(frame: cell.containerView.accessoryView.bounds)
            label.textAlignment = .Center
            label.textColor = .whiteColor()
            label.text = parties[indexPath.row].name
            label.font = .systemFontOfSize(30)
            cell.containerView.accessoryView.addSubview(label)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        
        let parties = EntitiesService.sharedInstance.getParties()

        if let cells = collectionView.visibleCells() as? [SAParallaxViewCell] {
            let containerView = SATransitionContainerView(frame: view.bounds)
            containerView.setViews(cells: cells, view: view)
            
            let viewController = EditPartyViewController()
            viewController.currentParty = parties[indexPath.row]
            viewController.transitioningDelegate = self
            viewController.trantisionContainerView = containerView
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
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
            if let _ = dismissed as? UINavigationController {
                transition.transitionMode = .Dismiss
                transition.startingPoint = addPartyBtn.center
                transition.bubbleColor = addPartyBtn.backgroundColor!
                
                self.collectionView.reloadData()
                
                return transition
            }
            return super.animationControllerForDismissedController(dismissed)
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
        view.backgroundColor = UIColor.grayColor()
        
        FacebookService.sharedInstance.getMe()
        FacebookService.sharedInstance.getMeProfilePicture()
        LocationService.sharedInstance.lastLocation //read current location
        
        self.addPartyBtn = UIButton(type: .Custom)
        addPartyBtn.backgroundColor = UIColor.blackColor()
        addPartyBtn.frame = CGRectMake(0,0, 48, 48)
        addPartyBtn.layer.cornerRadius = 0.5 * addPartyBtn.bounds.size.width
        addPartyBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(24)

        addPartyBtn.setTitle(String.fontAwesomeIconWithName(.Plus), forState: .Normal)
        addPartyBtn.setTitleColor(UIColor.greenColor(), forState: .Normal)
        
        addPartyBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), forControlEvents: .TouchUpInside)
        
        view.addSubview(addPartyBtn)
        
        addPartyBtn.anchorInCorner(.BottomRight, xPad: 30, yPad: 50, width: 50, height: 50)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
