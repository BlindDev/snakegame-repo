//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameBrain {
    
    private let side: CGFloat! = 10
    
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
    
    private var headPoint: CGPoint!
    
    private var screen: CGSize!
    
    private var fRect: CGRect!{
        get{
            let x = (screen.width % side)
            
            let y = (screen.height % side)
            
            let width = screen.width - x
            
            let height = screen.height - y
            
            return CGRect(x: x/2, y: y/2, width: width, height: height)
        }
    }
    
    private var bordersDictonary: [String:CGRect]!
    
    var borders: [CGRect]!{
        get{
            var bordersArray: [CGRect] = []
            
            for border in bordersDictonary.values {
                
               bordersArray.append(border)
            }
            return bordersArray
        }
    }
    
    private func createBorders(){

        let leftBorder = CGRect(x: fRect.origin.x, y: fRect.origin.y, width: side, height: fRect.height)
        
        bordersDictonary["Left"] = leftBorder
        
        let rightBorder = CGRect(x: screen.width - fRect.origin.x - side, y: fRect.origin.y, width: side, height: fRect.height)
        
        bordersDictonary["Right"] = rightBorder
        
        let topBorder = CGRect(x: side + fRect.origin.x, y: fRect.origin.y, width: fRect.width, height: side)
        
        bordersDictonary["Top"] = topBorder
        
        let botBorder = CGRect(x: side + fRect.origin.x, y: screen.height - fRect.origin.y - side, width: fRect.width, height: side)

        bordersDictonary["Bot"] = botBorder
        
        print(bordersDictonary)
    }

    var segments: [GameSegment]!
    
    private func randomPoint() -> CGPoint {
        
        let side32 = side.toUInt32()
        
        let width32 = (fRect.width - side * 2).toUInt32()
        
        let height32 = (fRect.height - side * 2).toUInt32()
        
        let randomMultiX = arc4random_uniform(width32 / side32) + 1
        
        let randomMultiY = arc4random_uniform(height32 / side32) + 1
        
        let newX: CGFloat = CGFloat(randomMultiX) * side + fRect.origin.x
        let newY: CGFloat! = CGFloat(randomMultiY) * side + fRect.origin.y
        
        return  CGPoint(x: newX, y: newY)
    }
    
    private func centerPoint() -> CGPoint {
        
        let x = calculatedMultiplier(fRect.width) * side + fRect.origin.x
        let y = calculatedMultiplier(fRect.height) * side + fRect.origin.y
        
        return CGPoint(x: x, y: y)
    }
    
    private func calculatedMultiplier(value: CGFloat) -> CGFloat{
        
        let multiplier = value / side
        
        return floor(multiplier / 2)
    }
    
    private var direction: (CGPoint)!
    
    func setDefaults(viewSize: CGSize){
        
        //prepareView
        bordersDictonary = [:]
        screen = viewSize
        createBorders()
        
        //prepare segments
        segments = []
        //main default point for the head
        headPoint = centerPoint()
        
        //setting default direction
        setDirection("Up")
        
        //creating the head
        let headSegment = GameSegment(point: headPoint, isEaten: true, side: side)
        segments.append(headSegment)
        
        //create segment to eat
        let newSegment = GameSegment(point: randomPoint(), isEaten: false, side: side)
        segments.append(newSegment)
    }
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        let outX = self.headPoint.x == fRect.origin.x || self.headPoint.x == fRect.origin.x - side + fRect.width
        let outY = self.headPoint.y == fRect.origin.y || self.headPoint.y == fRect.origin.y - side + fRect.height
        
        if outX || outY {
            headPoint = centerPoint()
        }else{
            moveHead()
        }
    }
    
    private func moveHead() {
        
        let headSegment = segments[0]
        headSegment.point = headPoint
        
        checkFood()
    }
    
    private func checkFood(){
        let headRect = segments[0].rect()
        
        let redSegment = segments[1].rect()//just check, can make an error
        
        let isEaten = CGRectIntersectsRect(headRect, redSegment)
        
        if isEaten {
            print("Eaten")
        }
    }
}

extension CGFloat{
    
    func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}