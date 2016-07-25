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
    
    private var direction: (CGPoint)!

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
    
    var borders: [GameSegment]!
    
    private var snake: [GameSegment]!
    
    private var food: GameSegment!
    
    var segments: [GameSegment]! {
        get{
            
            var array = snake
            array.append(food)
            return array
        }
    }
    
    func setDefaults() {
        
        //prepareView
        borders = []
        createBorders()
        
        //prepare segments
        snake = []
        //main default point for the head
        headPoint = centerPoint()
        
        //setting default direction
        setDirection("Up")
        
        //creating the head
        snake.append(headSegment())
        snake.append(headSegment())
        snake.append(headSegment())
        
        //create segment to eat
        food = newSegment()
    }
    
    init(viewSize: CGSize){
        screen = viewSize
        setDefaults()
    }
    
    private func createBorders(){
        
        let verticalCount = Int(fRect.height / side)
        //left border
        bordersCreationMethod(fRect.origin, direction: CGPoint(x: 0, y: side), count: verticalCount)
        
        //right border
        let rightX = screen.width - fRect.origin.x - side
        bordersCreationMethod(CGPoint(x: rightX, y: fRect.origin.y), direction: CGPoint(x: 0, y: side), count: verticalCount)
        
        let horizontalCount = Int(fRect.width / side) - 2
        //top border
        let horStartPoint = CGPoint(x: fRect.origin.x + side, y: fRect.origin.y)
        bordersCreationMethod(horStartPoint, direction: CGPoint(x: side, y: 0), count: horizontalCount)
        
        //bot border
        let botY = CGPoint(x: horStartPoint.x, y: screen.height - fRect.origin.y - side)
        bordersCreationMethod(botY, direction: CGPoint(x: side, y: 0), count: horizontalCount)
        
    }
    
    private func bordersCreationMethod(startP: CGPoint, direction: CGPoint, count: Int) {
        
        let startBorder = GameSegment(point: startP, side: side)
        startBorder.type = SegmentType.Border
        borders.append(startBorder)
        
        var cyclePoint = startP
        for _ in 1..<count {
            let borderPoint = CGPoint(x: cyclePoint.x + direction.x, y: cyclePoint.y + direction.y)
            let newBorder = GameSegment(point: borderPoint, side: side)
            newBorder.type = SegmentType.Border
            borders.append(newBorder)
            cyclePoint = borderPoint
        }
    }
    
    private func headSegment() -> GameSegment {
        let segment = GameSegment(point: headPoint, side: side)
        segment.type = SegmentType.Middle
        return segment
    }
    
    private func newSegment() -> GameSegment {
        let segment = GameSegment(point: randomPoint(), side: side)
        
        segment.type = SegmentType.Food

        return segment
    }
    
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
    
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        for border in borders {
            
            if border.parameters.rect.contains(headPoint) {
                
                print("Dead")
                //add the death
            }
        }
        
        moveHead()
    }
    
    private func moveHead() {
        
        guard let first = snake.first else{
            return
        }
        
        first.type = SegmentType.Middle
        
        let head = headSegment()
        head.type = SegmentType.Head
        snake.insert(head, atIndex: 0)
        
        snake.removeLast()
        guard let last = snake.last else{
            return
        }
        last.type = SegmentType.Tail
        
        checkFood()
    }
    
    private func checkFood(){
        guard let head = snake.first else{
            return
        }
        
        let isEaten = CGRectIntersectsRect(head.parameters.rect, food.parameters.rect)
        
        if isEaten {
            
//            food.isEaten = true
            
            snake.insert(food, atIndex: 0)
            
            food = newSegment()
        }
    }
}

extension CGFloat{
    
    func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}