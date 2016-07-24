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
    
    private var segmentViews: [UIView]! = []
    
    var delegate: DidDrawDelegate?
    
    var correctSize: CGSize!
    
    func renderSegments(segments: [GameSegment]){
            
        for i in 0..<segments.count {
            
            let segment = segments[i]
            
            var segmentView: UIView!
            
            if i == segmentViews.count {
                
                segmentView = UIView()
                self.addSubview(segmentView)
                segmentViews.append(segmentView)
            }
            
            segmentView = segmentViews[i]
                        
            segmentView.frame = segment.rect
            segmentView.backgroundColor = segment.color
        }
    }
    
    func renderBorders(borders: [Border]) {
                
        for border in borders{
            
            self.layer.addSublayer(border.layer)
        }
        
    }
    
    override func drawRect(rect: CGRect) {

        correctSize = rect.size
        
        delegate?.viewDidDraw()
    }
}
