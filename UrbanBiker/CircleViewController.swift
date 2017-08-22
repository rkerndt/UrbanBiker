//
//  CircleViewController.swift
//  UrbanBiker
//
//  Created by Ziming Guo on 8/22/17.
//  Copyright © 2017 zimingg. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AudioToolbox.AudioServices
import UserNotifications
import CoreMotion
import MapKit


import UIKit

class CircleView: UIView {
    
    var circle = UIView()
    var isAnimating = false
    
    var circleLayer: CAShapeLayer!
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        resetCircle()
//        addSubview(circle)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func resetCircle() {
        
        var rectSide: CGFloat = 0
        if (frame.size.width > frame.size.height) {
            rectSide = frame.size.height
        } else {
            rectSide = frame.size.width
        }
        
        let circleRect = CGRect(x: (frame.size.width-rectSide)/2, y: (frame.size.height-rectSide)/2, width: rectSide, height: rectSide)
        circle = UIView(frame: circleRect)
        circle.backgroundColor = UIColor.yellow
        circle.layer.cornerRadius = rectSide/2
        circle.layer.borderWidth = 2.0
        circle.layer.borderColor = UIColor.red.cgColor
    }
    
    func resizeCircle (summand: CGFloat) {
        
        frame.origin.x -= summand/2
        frame.origin.y -= summand/2
        
        frame.size.height += summand
        frame.size.width += summand
        
        circle.frame.size.height += summand
        circle.frame.size.width += summand
    }
    
    func animateChangingCornerRadius (toValue: Any?, duration: TimeInterval) {
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = circle.layer.cornerRadius
        animation.toValue =  toValue
        animation.duration = duration
        circle.layer.cornerRadius = self.circle.frame.size.width/2
        circle.layer.add(animation, forKey:"cornerRadius")
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    
    
    
    func circlePulseAinmation(_ summand: CGFloat, duration: TimeInterval, completionBlock:@escaping ()->()) {
        
        UIView.animate(withDuration: duration, delay: 0,  options: .curveEaseInOut, animations: {
            self.resizeCircle(summand: summand)
        }) { _ in
            completionBlock()
        }
        
        animateChangingCornerRadius(toValue: circle.frame.size.width/2, duration: duration)
        
    }
    
    func resizeCircleWithPulseAinmation(_ summand: CGFloat,  duration: TimeInterval) {
        
        if (!isAnimating) {
            isAnimating = true
            circlePulseAinmation(summand, duration:duration) {
                self.circlePulseAinmation((-1)*summand, duration:duration) {self.isAnimating = false}
            }
        }
    }}
