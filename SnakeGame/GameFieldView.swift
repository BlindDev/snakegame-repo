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
    
    fileprivate var segmentViews: [SegmentView]! = []
    
    var delegate: DidDrawDelegate?
    
    func renderSegments(_ segments: [GameSegment]){
            
        for (index, segment) in segments.enumerated() {
            
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
    
    override func draw(_ rect: CGRect) {
        
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
    
    fileprivate var open: Bool = true
    
    init(segment: GameSegment) {
        super.init(frame: segment.rect)
        
        backgroundColor = UIColor.clear
        self.segment = segment
    }
    
    
    override func draw(_ rect: CGRect) {
        
        open = !open
        
        switch segment.type {
        case .head:
            SnakeSegments.drawHead(open: open, angle: segment.direction.rawValue, bounds: bounds)
        case .tail:
            SnakeSegments.drawTail(angle: segment.direction.rawValue, bounds: bounds)
        case .middle:
            SnakeSegments.drawMiddle(bounds: bounds)
        case  .food:
            SnakeSegments.drawFood(bounds: bounds)
        case .border:
            SnakeSegments.drawBorder(bounds: bounds)
        }
    }
    
    
    func color() -> UIColor {
        switch segment.type {
        case .head:
            return UIColor.blue.withAlphaComponent(0.8)
        case .tail:
            return UIColor.yellow.withAlphaComponent(0.8)
        case .border:
            return UIColor.gray
        case .food:
            return UIColor.red
        case.middle:
            return UIColor.green.withAlphaComponent(0.8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











