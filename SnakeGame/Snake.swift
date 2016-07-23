//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameSegment {
    var isEaten: Bool! {
        didSet{
            color = newColor()
        }
    }
    var color: UIColor!
    var point: CGPoint!
    
    init(point: CGPoint, isEaten: Bool){
        
        self.point = point
        self.isEaten = isEaten
        color = newColor()
    }
    
    private func newColor() -> UIColor{
        return isEaten == true ? UIColor.greenColor() : UIColor.redColor()
    }
    
    func segmentRect() -> CGRect {
        
        let side: CGFloat = 10
        
        return CGRect(x: point.x + side / 2, y: point.y + side / 2, width: side, height: side)
    }
}