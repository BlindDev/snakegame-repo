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
    
    private var headPoint: CGPoint! = CGPointZero
    
    private var screen: CGSize!
    
    private var insets: CGPoint!{
        get{
            let horizontal = (screen.width % side) / 2
            
            let vertical = (screen.height % side) / 2
            
            return CGPoint(x: horizontal, y: vertical)
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
        
        let width = screen.width - insets.x * 2
        
        let height = screen.height - insets.y * 2

        let leftBorder = CGRect(x: insets.x, y: insets.y, width: side, height: height)
        
        bordersDictonary["Left"] = leftBorder
        
        let rightBorder = CGRect(x: screen.width - insets.x - side, y: insets.y, width: side, height: height)
        
        bordersDictonary["Right"] = rightBorder
        
        let topBorder = CGRect(x: side + insets.x, y: insets.y, width: width, height: side)
        
        bordersDictonary["Top"] = topBorder
        
        let botBorder = CGRect(x: side + insets.x, y: screen.height - insets.y - side, width: width, height: side)

        bordersDictonary["Bot"] = botBorder        
    }

    var segments: [GameSegment]!
    
    private func createRandomSegment(){
        
        let side32 = side.convertToUInt32()
        
        let width32 = screen.width.convertToUInt32()
        
        let height32 = screen.height.convertToUInt32()
        
        let randomMultiX = arc4random_uniform(width32 / side32 - side32)
        
        let randomMultiY = arc4random_uniform(height32 / side32 - side32)
        
        let newX: CGFloat = CGFloat(randomMultiX) * side
        let newY: CGFloat! = CGFloat(randomMultiY) * side
        
        let newPoint = CGPoint(x: newX, y: newY)

        let newSegment = GameSegment(point: newPoint, isEaten: false, side: side)
        segments.append(newSegment)
        
        print(newPoint)
    }
    
    private var direction: (CGPoint)!
    
    func setDefaultPosition(defaultPosition: CGPoint, viewSize: CGSize){
        
        //prepareView
        bordersDictonary = [:]
        screen = viewSize
        createBorders()
        
        //prepare segments
        segments = []
        //main default point for the head
        headPoint.x = defaultPosition.x
        headPoint.y = defaultPosition.y
        
        //setting default direction
        setDirection("Up")
        
        //creating the head
        let headSegment = GameSegment(point: headPoint, isEaten: true, side: side)
        segments.append(headSegment)
        
        //create segment to eat
        createRandomSegment()
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
        
        let redSegment = segments[1].segmentRect()//just check, can make an error
        
        let isEaten = CGRectIntersectsRect(headRect, redSegment)
        
        if isEaten {
            print("Eaten")
        }
    }
}

extension CGFloat{
    
    func convertToUInt32() -> UInt32 {
        return UInt32(self)
    }
}