//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

enum Direction: CGFloat {
    case Up = 0
    case Down = 180
    case Left = 90
    case Right = 270
}

enum SegmentType{
    case Head
    case Tail
    case Border
    case Middle
    case Food
}

class GameSegment {
    
    private var point: CGPoint!
    
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