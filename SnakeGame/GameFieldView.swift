//
//  GameFieldView.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameFieldView: UIView {
    
    private var segmentViews: [UIView]! = []
    
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
            
            segmentView.frame = segment.segmentRect()
            segmentView.backgroundColor = segment.color
        }
    }
}
