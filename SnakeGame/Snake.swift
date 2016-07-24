//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

enum SegmentTypes{
    case Head
    case Tail
    case Middle
    case Food
    case Border
}

class GameSegment {
    var isEaten: Bool!
    
    var rect: CGRect!{
        get{
            return CGRect(x: point.x, y: point.y, width: side, height: side)
        }
    }
    
    var type: SegmentTypes!
    
    private var point: CGPoint!
    private var side: CGFloat!
    
    init(point: CGPoint, side: CGFloat, type: SegmentTypes){
        
        self.point = point
        self.side = side
        self.type = type
        self.isEaten = false
    }
}