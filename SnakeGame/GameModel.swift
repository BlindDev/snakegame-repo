//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

let side: CGFloat = UIScreen.mainScreen().bounds.width / 30

protocol BrainDelegate {
    func snakeIsDead()
}

class GameBrain {
    
    var delegate: BrainDelegate?
    
    private var direction: (CGPoint)!
    
    func setDirection(gestureDirection: String){
        
        let movements = [
            "Up" : CGPointMake(0,-side),
            "Down" : CGPointMake(0,side),
            "Left" : CGPointMake(-side,0),
            "Right" : CGPointMake(side,0)
        ]
        
        if let action = movements[gestureDirection] {
            
            if direction == nil || !(direction.x + action.x == 0 && direction.y + action.y == 0) {
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
    
    init(viewSize: CGSize){
        
        screen = viewSize
        
        //prepareView
        borders = []
        createBorders()
        
        //setting default direction
        setDirection("Up")
        
        //snake body
        snake = []
        headPoint = centerPoint()
        snake.append(headSegment())
        snake.append(headSegment())
        snake.append(headSegment())
        
        //create segment to eat
        food = newSegment()
    }
    
    private func createBorders(){
        
        func bordersCreationMethod(startP: CGPoint, direction: CGPoint, count: Int) {
            
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
        
        func randomMultiplier(value: CGFloat, coord: CGFloat) -> CGFloat {
            
            let parameter = (value - side * 2 - coord * 2).toUInt32()
            
            let side32 = side.toUInt32()
            
            var multiplier: UInt32!
            
            multiplier = arc4random_uniform(parameter / side32)
            
            if multiplier <= 0 {
                multiplier = 1
            }
            
            return CGFloat(multiplier) * side + coord
        }
        
        let newX = randomMultiplier(fRect.width, coord: fRect.origin.x)
        let newY = randomMultiplier(fRect.height, coord: fRect.origin.y)
        
        return  CGPoint(x: newX, y: newY)
    }
    
    private func centerPoint() -> CGPoint {
        
        func calculatedMultiplier(value: CGFloat, coord: CGFloat) -> CGFloat{
            
            let multiplier = value / side
            
            return floor(multiplier / 2) * side + coord
        }
        
        let x = calculatedMultiplier(fRect.width, coord: fRect.origin.x)
        let y = calculatedMultiplier(fRect.height, coord: fRect.origin.y)
        
        return CGPoint(x: x, y: y)
    }
    
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        for border in borders {
            
            if border.parameters.rect.contains(headPoint) {
                
                delegate?.snakeIsDead()
                return
            }
        }
        
        for segment in snake {
            if segment.parameters.rect.contains(headPoint) {
                
                delegate?.snakeIsDead()
                return
            }
        }
        
        moveHead()
        
        if food.parameters.rect.contains(headPoint) {
            snake.insert(food, atIndex: 0)
            
            food = newSegment()
        }
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
    }
    
}

extension CGFloat{
    
    func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}