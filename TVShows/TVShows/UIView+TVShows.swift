//
//  UIView+TVShows.swift
//  TVShows
//
//  Created by Ivan Almer on 24/07/2018.
//  Copyright © 2018 ialmer. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func shake() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(translationX: -10, y: 0)
            
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 40, options: [.curveEaseInOut], animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
    
    func show(withDuration delay: TimeInterval) {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1
        }) { (finished) in
            if !finished { return }
            UIView.animate(withDuration: 0.1, delay: delay, options: [.curveEaseInOut], animations: {
                self.alpha = 0
            })
        }
    }
    
}

