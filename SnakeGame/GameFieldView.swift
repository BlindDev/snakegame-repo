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
                segmentViews[index].segment = segment
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

enum SegmentType{
    case Head
    case Tail
    case Border
    case Middle
    case Food
}

class SegmentView: UIView {
    
    var segment: GameSegment!{
        didSet{
            frame = segment.rect
            
//            UIView.animateWithDuration(0.10, animations: {
//                self.frame = self.segment.rect
//            })
            
            setNeedsDisplay()
        }
    }
    
    init(segment: GameSegment) {
        super.init(frame: segment.rect)
        
        backgroundColor = UIColor.clearColor()
        self.segment = segment
    }
    
    
    override func drawRect(rect: CGRect) {
        color().setFill()
        path().fill()
    }
    
    func path() -> UIBezierPath {
        
        switch segment.type {
        case .Head, .Tail, .Middle, .Food:
            return UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        case .Border:
            let fillRect = CGRect(x: 1, y: 1, width: bounds.width-2, height: bounds.width - 2)
            return UIBezierPath(roundedRect: fillRect, cornerRadius: bounds.width/5)
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











