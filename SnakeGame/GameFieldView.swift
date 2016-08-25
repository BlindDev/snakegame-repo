//
//  GameFieldView.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

protocol DidDrawDelegate {
    func viewDidDraw()
}

class GameFieldView: UIView {
    
    private var segmentViews: [SegmentView]! = []
    
    var delegate: DidDrawDelegate?
    
    func renderSegments(segments: [GameSegment]){
            
        for (index, segment) in segments.enumerate() {
            
            if index == segmentViews.count {
                
                let segmentView = SegmentView(segment: segment)
                
                self.addSubview(segmentView)
                segmentViews.append(segmentView)
                
            }else{
                
                if segmentViews[index].segment.rect != segment.rect {
                    segmentViews[index].segment = segment
                }
            }
        }
    }
    
    func clearSubviews() {
        
        segmentViews = []
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        delegate?.viewDidDraw()
    }
}


class SegmentView: UIView {
    
    var segment: GameSegment!{
        didSet{
            
            frame = segment.rect
            
            setNeedsDisplay()
        }
    }
    
    private var open: Bool = true
    
    init(segment: GameSegment) {
        super.init(frame: segment.rect)
        
        backgroundColor = UIColor.clearColor()
        self.segment = segment
    }
    
    
    override func drawRect(rect: CGRect) {
        
        open = !open
        
        switch segment.type {
        case .Head:
            SnakeSegments.drawHead(open: open, angle: segment.direction.rawValue, bounds: bounds)
        case .Tail:
            SnakeSegments.drawTail(angle: segment.direction.rawValue, bounds: bounds)
        case .Middle:
            SnakeSegments.drawMiddle(bounds: bounds)
        case  .Food:
            SnakeSegments.drawFood(bounds: bounds)
        case .Border:
            SnakeSegments.drawBorder(bounds: bounds)
        }
    }
    
    
    func color() -> UIColor {
        switch segment.type {
        case .Head:
            return UIColor.blueColor().colorWithAlphaComponent(0.8)
        case .Tail:
            return UIColor.yellowColor().colorWithAlphaComponent(0.8)
        case .Border:
            return UIColor.grayColor()
        case .Food:
            return UIColor.redColor()
        case.Middle:
            return UIColor.greenColor().colorWithAlphaComponent(0.8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











