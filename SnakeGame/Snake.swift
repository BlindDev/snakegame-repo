//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameSegment {
    
    var color: UIColor!
    var point: CGPoint!
    var side: CGFloat!
    
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
    override init(point: CGPoint, side: CGFloat) {
        super.init(point: point, side: side)
        
        color = UIColor.blackColor()
    }
}