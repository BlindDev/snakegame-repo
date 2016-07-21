//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameBrain {
    
    private var actions: Dictionary <String, (CGPoint)> = [
        "Up" : CGPointMake(0,-10),
        "Down" : CGPointMake(0,10),
        "Left" : CGPointMake(-10,0),
        "Right" : CGPointMake(10,0)
    ]
    
    func setDirection(buttonAction: String){
        
        if let action = actions[buttonAction] {
            
            if (direction != nil) {
                if !(direction.x + action.x == 0 && direction.y + action.y == 0) {
                    direction = action
                }
            }else{
                direction = action
            }
        }
    }
    
    private var headPoint: CGPoint! = CGPointZero
    
    private var backViewSize: CGSize!
    
    var segments: [GameSegment]! = []
    
    private func createSegment(){
        
        let screen = backViewSize
        
        let step:UInt32 = 10
        
        let screenWidth = UInt32(screen.width)
        
        let screenHeight = UInt32(screen.height)
        
        let offsetX =  screenWidth % step
        
        let offsetY = screenHeight % step
        
        let randomMultiplierX = arc4random_uniform(screenWidth/10 - offsetX)
        
        let randomMultiplierY = arc4random_uniform(screenWidth/10 - offsetY)
        
        let newX: CGFloat = CGFloat(randomMultiplierX * step)
        let newY: CGFloat! = CGFloat(randomMultiplierY * step)
        
        let newPoint = CGPoint(x: newX, y: newY)

        let newSegment = GameSegment()
        newSegment.isEaten = false
        newSegment.color = UIColor.redColor()
        newSegment.point = newPoint
        segments.append(newSegment)
        
        print(newPoint)
    }
    
    var direction: (CGPoint)!
    
    func setDefaultPosition(defaultPosition: CGPoint, viewSize: CGSize){
        
        headPoint.x = defaultPosition.x
        headPoint.y = defaultPosition.y
        
        backViewSize = viewSize
        
        setDirection("Up")
        
        let headSegment = GameSegment()
        headSegment.isEaten = true
        headSegment.color = UIColor.greenColor()
        headSegment.point = headPoint
        segments.append(headSegment)
        
        createSegment()
    }
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        moveHead()
    }
    
    private func moveHead() {
        
        let headSegment = segments[0]
        headSegment.point = headPoint
        
        checkFood()
    }
    
    private func checkFood(){
        let headRect = segments[0].segmentRect()
        
        let redSegment = segments[1].segmentRect()
        
        let isEaten = CGRectIntersectsRect(headRect, redSegment)
        
        if isEaten {
            print("Eaten")
        }
    }
}

class GameSegment {
    var isEaten: Bool!
    var color: UIColor!
    var point: CGPoint!
    
    func segmentRect() -> CGRect {
        
        let side: CGFloat = 10
        
        return CGRect(x: point.x + side / 2, y: point.y + side / 2, width: side, height: side)
    }
}