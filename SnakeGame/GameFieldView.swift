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
    
    private var borderViews: [SegmentView]!
    
    var delegate: DidDrawDelegate?
    
    var correctSize: CGSize!
    
    func renderSegments(segments: [GameSegment]){
            
        for i in 0..<segments.count {
            
            let segment = segments[i]
            
            var segmentView: SegmentView!
            
            if i == segmentViews.count {
                
                segmentView = SegmentView(frame: segment.rect, type: segment.type)
                self.addSubview(segmentView)
                segmentViews.append(segmentView)
            }else{
                segmentView = segmentViews[i]
                segmentView.frame = segment.rect
            }
            
        }
    }
    
    func renderBorders(borders: [GameSegment]) {
        
        borderViews = []
        
        for border in borders{
            
            let borderView = SegmentView(frame: border.rect, type: border.type)                        
            self.addSubview(borderView)
        }
        
    }
    
    override func drawRect(rect: CGRect) {

        correctSize = rect.size
        
        delegate?.viewDidDraw()
    }
}

class SegmentView: UIView {
    
    var type: SegmentTypes! {
        didSet{
            setNeedsDisplay()
        }
    }
    
    init(frame: CGRect, type: SegmentTypes) {
        super.init(frame: frame)
        
        self.type = type
    }
    
    override func drawRect(rect: CGRect) {
        
        var path: UIBezierPath!
        
        switch self.type {
        case .Head:
            path = headPath()
        default:
            <#code#>
        }
    }
    
    private func headPath() -> UIBezierPath {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
