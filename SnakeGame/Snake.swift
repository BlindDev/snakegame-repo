//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

enum Direction: CGFloat {
    case up = 0
    case down = 180
    case left = 90
    case right = 270
}

enum SegmentType{
    case head
    case tail
    case border
    case middle
    case food
}

class GameSegment {
    
    fileprivate var point: CGPoint!
    
    var direction: Direction! 

    var rect: CGRect {
        get{
            return CGRect(x: point.x, y: point.y, width: side, height: side)
        }
    }
    
    var type: SegmentType
    
    init(point: CGPoint, type: SegmentType){
        
        self.point = point
        self.type = type
    }
}
