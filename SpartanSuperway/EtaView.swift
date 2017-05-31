//
//  EtaView.swift
//  SpartanSuperway
//
//  Created by Stephen Piazza on 4/5/17.
//  Copyright © 2017 SpartanSuperway. All rights reserved.
//

import UIKit
@IBDesignable
class EtaView: UIView {
    
    @IBInspectable
    open var eta: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var centerColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var gifImage: UIImage = UIImage.gifImageWithName("hello")! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let startAngle: CGFloat = CGFloat(2 * Double.pi / 3)
        let endAngle: CGFloat =  CGFloat(Double.pi / 3)
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let arcWidth: CGFloat = 20
        
        let radius: CGFloat = min(bounds.width, bounds.height)
       
        //Draw the shadow for the eta Circle
        let shadow = UIBezierPath(ovalIn: CGRect(x: bounds.width/2 - radius/2, y: bounds.height - 40, width: radius, height: 30))
        UIColor.gray.setFill()
        shadow.fill(with: CGBlendMode.normal, alpha: 0.1)

        //Draw the Eta update semi circle
        let bezierPath = UIBezierPath(arcCenter: center,
                                      radius: radius/2 - arcWidth/2,
                                      startAngle: startAngle,
                                      endAngle: endAngle*eta,
                                      clockwise: true)
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineWidth = arcWidth
        
        UIColor.init(red: 0.0, green: 0.33, blue: 0.63, alpha: 1.0).setStroke()
        bezierPath.stroke()
        
        
        //Draw the inner circle
//        let circle = UIBezierPath(arcCenter: center,
//                                  radius: radius/2-arcWidth,
//                                  startAngle: 0,
//                                  endAngle: CGFloat(2*Double.pi),
//                                  clockwise: true)
//        centerColor.setFill()
//        circle.fill()

       let gifImageView = UIImageView(image: gifImage)
        gifImageView.frame = CGRect(x: arcWidth*1.5,y: arcWidth, width: radius-arcWidth*2, height: radius-arcWidth*2)
        gifImageView.layer.cornerRadius = gifImageView.bounds.size.width/2
        gifImageView.clipsToBounds = true
        self.addSubview(gifImageView)
//
        
        //        self.gifImageView.image = sunnyGif
        //        self.gifImageView.layer.cornerRadius = self.gifImageView.frame.size.width/2
        //        self.gifImageView.clipsToBounds = true

        
        
    }
    
}
