//
//  ViewController.swift
//  Door
//
//  Created by Matt Long on 3/16/16.
//  Copyright © 2016 Matt Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var slideLayer:CALayer!
    var baseLayer:CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("didTapView:")))
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.addLayers()
        
    }
    
    func addLayers() {
        baseLayer = CALayer()
        baseLayer.borderWidth = 10.0
        baseLayer.bounds = CGRect(x: 0.0, y: 0.0, width: 220, height: 500.0)
        baseLayer.masksToBounds = true
        baseLayer.position = self.view.center
        
        slideLayer = CALayer()
        slideLayer.bounds = baseLayer.bounds
        slideLayer.backgroundColor = UIColor.whiteColor().CGColor
        slideLayer.position = CGPoint(x: baseLayer.bounds.size.width / 2.0, y: baseLayer.bounds.size.height / 2.0)

        let knobLayer = CALayer()
        knobLayer.bounds = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        knobLayer.cornerRadius = 10.0
        knobLayer.backgroundColor = UIColor.blueColor().CGColor
        knobLayer.position = CGPoint(x: 30.0, y: slideLayer.bounds.size.height / 2.0)
        
        slideLayer.addSublayer(knobLayer)
        
        baseLayer.addSublayer(slideLayer)
        
        self.view.layer.addSublayer(baseLayer)
    }
    
    func didTapView(gesture:UITapGestureRecognizer) {
        
        // Create a couple of closures to perform the animations. Each
        // closure takes a completion block as a parameter. This will
        // be used as the completion block for the Core Animation transaction's
        // completion block.
        
        let slideAnimation = {
            (completion:(() -> ())?) in
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            CATransaction.setAnimationDuration(1.0)
            if CATransform3DIsIdentity(self.slideLayer.transform) {
                self.slideLayer.transform = CATransform3DMakeTranslation(220.0, 0.0, 0.0)
            } else {
                self.slideLayer.transform = CATransform3DIdentity
            }
            CATransaction.commit()
        }
        
        let scaleAnimation = {
            (completion:(() -> ())?) in
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            CATransaction.setAnimationDuration(1.0)
            if CATransform3DIsIdentity(self.baseLayer.transform) {
                self.baseLayer.transform = CATransform3DMakeScale(2.0, 2.0, 2.0)
            } else {
                self.baseLayer.transform = CATransform3DIdentity
            }
            CATransaction.commit()
        }
        
        // Check to see if the slide layer's transform is the identity transform
        // which would mean that the door is currently closed.
        if CATransform3DIsIdentity(self.slideLayer.transform) {
            // If the door is closed, perform the slide animation
            slideAnimation( {
                // And when it completes, perform the scale animation
                scaleAnimation(nil) // Pass nil here since we're done animating
            } )
        } else {
            // Otherwise the door is open, so perform the scale (down)
            // andimation first
            scaleAnimation( {
                // And when it completes, perform the slide animation
                slideAnimation(nil) // Pass nil here since we're done animating
            })
        }
    }
}

