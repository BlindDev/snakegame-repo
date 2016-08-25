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