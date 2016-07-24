//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameSegment {
    
    private var point: CGPoint!
    private var side: CGFloat!
    
    var color: UIColor!
    
    var rect: CGRect {
        get{
            return CGRect(x: point.x, y: point.y, width: side, height: side)
        }
    }
    
    init(point: CGPoint, side: CGFloat){
        
        self.point = point
        self.side = side
    }
}

class SnakeSegment: GameSegment {
    
    var isEaten: Bool! {
        didSet{
            color = isEaten == true ? UIColor.greenColor().colorWithAlphaComponent(0.8) : UIColor.redColor()
        }
    }
    
    override init(point: CGPoint, side: CGFloat) {
        super.init(point: point, side: side)
        
        color = UIColor.redColor()
    }
}

class Border: GameSegment {
    
    var layer: CAShapeLayer!
    
    override init(point: CGPoint, side: CGFloat) {
        super.init(point: point, side: side)
                
        layer = CAShapeLayer()
        layer.path = rectLayer().CGPath
        layer.fillColor = UIColor.blackColor().CGColor
    }
    
    private func rectLayer() -> UIBezierPath {
        
        let fillRect = CGRect(x: rect.minX + 1, y: rect.minY + 1, width: side-2, height: side - 2)
        
        let path = UIBezierPath(roundedRect: fillRect, cornerRadius: side/5)
        
        return path
    }
}