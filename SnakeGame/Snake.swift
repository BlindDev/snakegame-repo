//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit


enum SegmentType{
    case Head
    case Tail
    case Border
    case Middle
    case Food
}

struct SegmentParameters {
    
    var rect: CGRect
    var type: SegmentType
    
    func path() -> UIBezierPath {
        
        switch type {
        case .Head, .Tail, .Middle, .Food:
            return UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        default:
            let fillRect = CGRect(x: 1, y: 1, width: rect.width-2, height: rect.width - 2)
            
            return UIBezierPath(roundedRect: fillRect, cornerRadius: rect.width/5)
        }
    }
    
    func color() -> UIColor {
        switch type {
        case .Head:
            return UIColor.blueColor().colorWithAlphaComponent(0.8)
        case .Tail:
            return UIColor.yellowColor()
        case .Border:
            return UIColor.grayColor()
        case .Food:
            return UIColor.redColor()
        case.Middle:
            return UIColor.greenColor().colorWithAlphaComponent(0.8)
        }
    }
    
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
    
    private var rect: CGRect {
        get{
            return CGRect(x: point.x, y: point.y, width: side, height: side)
        }
    }
    
    init(point: CGPoint, side: CGFloat){
        
        self.point = point
        self.side = side
    }
    
    private func updateParameters(){
        
        parameters = SegmentParameters(rect: rect, type: type)
    }
}