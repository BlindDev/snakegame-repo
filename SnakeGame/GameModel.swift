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
        
        let screen = backViewSize
        
        let borderWidth:CGFloat = 10
        
        let leftBorder = CGRect(x: 0, y: 0, width: borderWidth, height: screen.height)
        
        bordersDictonary["Left"] = leftBorder
        
        let rightBorder = CGRect(x: screen.width - borderWidth, y: 0, width: borderWidth, height: screen.height)
        
        bordersDictonary["Right"] = rightBorder
        
        let horBorderWidth = screen.width - borderWidth * 2
        
        let topBorder = CGRect(x: borderWidth, y: 0, width: horBorderWidth, height: borderWidth)
        
        bordersDictonary["Top"] = topBorder
        
        let botBorder = CGRect(x: borderWidth, y: screen.height - borderWidth, width: horBorderWidth, height: borderWidth)

        bordersDictonary["Bot"] = botBorder
        
        print(bordersDictonary)
    }

    var segments: [GameSegment]!
    
    private func createRandomSegment(){
        
//        let randomMultiplierX = arc4random_uniform(screenWidth/10 - offsetX)
//        
//        let randomMultiplierY = arc4random_uniform(screenWidth/10 - offsetY)
//        
//        let newX: CGFloat = CGFloat(randomMultiplierX * step)
//        let newY: CGFloat! = CGFloat(randomMultiplierY * step)
//        
//        let newPoint = CGPoint(x: newX, y: newY)
//
//        let newSegment = GameSegment(point: newPoint, isEaten: false)
//        segments.append(newSegment)
//        
//        print(newPoint)
    }
    
    private var direction: (CGPoint)!
    
    func setDefaultPosition(defaultPosition: CGPoint, viewSize: CGSize){
        
        //prepareView
        bordersDictonary = [:]
        backViewSize = viewSize
        createBorders()
        
        //prepare segments
        segments = []
        //main default point for the head
        headPoint.x = defaultPosition.x
        headPoint.y = defaultPosition.y
        
        //setting default direction
        setDirection("Up")
        
        //creating the head
        let headSegment = GameSegment(point: headPoint, isEaten: true)
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
        
//        checkFood()
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