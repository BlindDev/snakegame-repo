//
//  Snake.swift
//  SnakeGame
//
//  Created by Pavel Popov on 23.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameSegment {
    var isEaten: Bool!{
        didSet{
            isEatenAction()
        }
    }
    
    var color: UIColor!
    var point: CGPoint!
    var side: CGFloat!
    
    init(point: CGPoint, side: CGFloat){
        
        self.point = point
        self.side = side
        self.isEaten = false
        isEatenAction()
    }
    
    private func isEatenAction(){}
    
    func rect() -> CGRect {
        
        return CGRect(x: point.x, y: point.y, width: side, height: side)
    }
}

class SnakeSegment: GameSegment {
    var isHead: Bool!{
        didSet{
            head()
        }
    }
    
    var isTail: Bool!{
        didSet{
            tail()
        }
    }
    
    private func head(){
        color = isHead == true ? UIColor.blueColor() : UIColor.greenColor()
    }
    
    private func tail(){
        color = isTail == true ? UIColor.grayColor() : UIColor.greenColor()
    }
    
    override init(point: CGPoint, side: CGFloat) {
        super.init(point: point, side: side)
    }
    
    override func isEatenAction() {
        color = isEaten == true ? UIColor.greenColor() : UIColor.redColor()
    }
}

class Border: GameSegment {
    override init(point: CGPoint, side: CGFloat) {
        super.init(point: point, side: side)
    }
    
    private override func isEatenAction() {
        color = isEaten == true ? UIColor.redColor() : UIColor.blackColor()
    }
}