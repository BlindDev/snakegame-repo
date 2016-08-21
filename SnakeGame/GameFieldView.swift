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
    
    var correctSize: CGSize!
    
    func renderSegments(segments: [GameSegment]){
            
        for i in 0..<segments.count {
            
            let segment = segments[i]
            
            var segmentView: SegmentView!
            
            if i == segmentViews.count {
                
                let params = segment.parameters
                segmentView = SegmentView(parameters: params)
                self.addSubview(segmentView)
                segmentViews.append(segmentView)
            }else{
                segmentView = segmentViews[i]
                
                segmentView.parameters = segment.parameters
            }
        }
    }
    
    func renderBorders(borders: [GameSegment]) {
                
        for border in borders{
            
            let params = border.parameters
            let view = SegmentView(parameters: params)
            addSubview(view)
        }
        
    }
    
    override func drawRect(rect: CGRect) {

        correctSize = rect.size
        
        delegate?.viewDidDraw()
    }
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
        let path = parameters.path()
        parameters.color().setFill()
        path.fill()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}











