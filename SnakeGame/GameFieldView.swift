//
//  GameFieldView.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

struct SegmentParameters {
    
    var rect: CGRect
    var type: SegmentType
    
    init(segment: GameSegment){
        
        self.rect = segment.rect
        self.type = segment.type
    }
}

protocol DidDrawDelegate {
    func viewDidDraw()
}

class GameFieldView: UIView {
    
    private var segmentViews: [SegmentView]! = []
    
    var delegate: DidDrawDelegate?
    
    func renderSegments(segments: [GameSegment]){
            
        for (index, value) in segments.enumerate() {
            
            let parameters = SegmentParameters(segment: value)
            
            if index == segmentViews.count {
                
                let segmentView = SegmentView(parameters: parameters)
                
                self.addSubview(segmentView)
                segmentViews.append(segmentView)
                
            }else{
                segmentViews[index].parameters = parameters
            }
        }
    }
    
    func renderBorders(borders: [GameSegment]) {
                
        for border in borders{
            
            let parameters = SegmentParameters(segment: border)

            let view = SegmentView(parameters: parameters)
            
            addSubview(view)
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
    
    var parameters: SegmentParameters!{
        didSet{
            frame = parameters.rect
            setNeedsDisplay()
        }
    }
    
    init(parameters: SegmentParameters) {
        super.init(frame: parameters.rect)
        
        backgroundColor = UIColor.clearColor()
        self.parameters = parameters
    }
    
    
    override func drawRect(rect: CGRect) {
        color().setFill()
        path().fill()
    }
    
    func path() -> UIBezierPath {
        
        switch parameters.type {
        case .Head, .Tail, .Middle, .Food:
            return UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        default:
            let fillRect = CGRect(x: 1, y: 1, width: bounds.width-2, height: bounds.width - 2)
            
            return UIBezierPath(roundedRect: fillRect, cornerRadius: bounds.width/5)
        }
    }
    
    func color() -> UIColor {
        switch parameters.type {
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











