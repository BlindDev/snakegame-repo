//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

struct SegmentParameters {
    
    var rect: CGRect
    var type: SegmentType
}

class GameSegment {
    
    private var point: CGPoint!
    private var side: CGFloat!
    
    var parameters: SegmentParameters!
    
    var type: SegmentType! {
        didSet{
            updateParameters()
        }
    }
    
    init(point: CGPoint, side: CGFloat){
        
        self.point = point
        self.side = side
    }
    
    private func updateParameters(){
        
        let rect = CGRect(x: point.x, y: point.y, width: side, height: side)
        parameters = SegmentParameters(rect: rect, type: type)
    }
}