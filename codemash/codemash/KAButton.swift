//
//  KAButton.swift
//  codemash
//
//  Created by Kim Arnett on 12/8/16.
//  Copyright © 2016 karnett. All rights reserved.


import Foundation
import UIKit
import pop

class KAButton: UIButton {
    
    enum POPAnimationStyle {
        case spring
    }
    
    var animationStyle: POPAnimationStyle = .spring
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if self.animationStyle == .spring {
            animateSpringIn()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
        if self.animationStyle == .spring {
            animateSpringOut()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        
        if self.animationStyle == .spring {
            animateSpringOut()
        }
    }
    
    func animateSpringIn() {
        
        let animation = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
        animation?.toValue = NSValue.init(cgPoint: CGPoint(x: 0.9, y: 0.9))
        animation?.velocity = NSValue.init(cgPoint: CGPoint(x: 2.0, y: 2.0))
        animation?.springBounciness = 20.0
        self.pop_add(animation, forKey: "buttonAnimationIn")
    }
    
    func animateSpringOut() {
        let animation = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
        animation?.velocity = NSValue.init(cgPoint: CGPoint(x: 2.0, y: 2.0))
        animation?.springBounciness = 20.0
        animation?.toValue = NSValue.init(cgPoint: CGPoint(x: 1.0, y: 1.0))
        self.pop_add(animation, forKey: "buttonAnimationOut")
    }
}

