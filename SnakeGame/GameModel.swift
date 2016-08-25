//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

let side: CGFloat = UIScreen.mainScreen().bounds.width / 20

protocol BrainDelegate {
    func snakeIsDeadWithScore(value: Int)
    func updateScoreWithScore(value: Int)
}

class GameBrain {
    
    var delegate: BrainDelegate?
    
    private var direction: (CGPoint)!
    
    func setDirection(gestureDirection: UISwipeGestureRecognizerDirection){
        
        var newDirection: CGPoint!
        
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.Right:
            newDirection = CGPointMake(side,0)
        case UISwipeGestureRecognizerDirection.Down:
            newDirection = CGPointMake(0,side)
        case UISwipeGestureRecognizerDirection.Left:
            newDirection = CGPointMake(-side,0)
        case UISwipeGestureRecognizerDirection.Up:
            newDirection = CGPointMake(0,-side)
        default:
            break
        }
        
        if direction == nil || !(direction.x + newDirection.x == 0 && direction.y + newDirection.y == 0) {
            direction = newDirection
        }
    }
    
    private var headPoint: CGPoint!
    
    private var field: CGRect!
    
    private var borders: [GameSegment]!
    
    private var snake: [GameSegment]!
    
    private var food: GameSegment!
    
    var segments: [GameSegment]! {
        get{
            var array = snake + borders
            array.append(food)
            return array
        }
    }
    
    init(viewSize: CGSize) {
        
        let x = (viewSize.width % side)
        
        let y = (viewSize.height % side)
        
        field = CGRect(x: x/2, y: y/2, width: viewSize.width - x, height: viewSize.height - y)
        
        score = 0
        
        //prepareView
        borders = []
        createBorders()
        
        //setting default direction
        setDirection(UISwipeGestureRecognizerDirection.Up)
        
        headPoint = centerPoint()
        //snake body
        snake = []
        snake.append(headSegment())
        snake.append(headSegment())
        
        //create segment to eat
        food = newSegment()
    }
    
    private func createBorders(){
        
        func bordersCreationMethod(startP: CGPoint, direction: CGPoint, count: Int) {
            
            let startBorder = GameSegment(point: startP, type: .Border)
            borders.append(startBorder)
            
            var cyclePoint = startP
            for _ in 1..<count {
                let borderPoint = CGPoint(x: cyclePoint.x + direction.x, y: cyclePoint.y + direction.y)
                let newBorder = GameSegment(point: borderPoint, type: .Border)
                borders.append(newBorder)
                cyclePoint = borderPoint
            }
        }
        
        let verticalCount = Int(field.height / side)
        //left border
        bordersCreationMethod(field.origin, direction: CGPoint(x: 0, y: side), count: verticalCount)
        
        //right border
        let rightX = field.origin.x + field.width - side
        bordersCreationMethod(CGPoint(x: rightX, y: field.origin.y), direction: CGPoint(x: 0, y: side), count: verticalCount)
        
        let horizontalCount = Int(field.width / side) - 2
        //top border
        let horStartPoint = CGPoint(x: field.origin.x + side, y: field.origin.y)
        bordersCreationMethod(horStartPoint, direction: CGPoint(x: side, y: 0), count: horizontalCount)
        
        //bot border
        let botY = CGPoint(x: horStartPoint.x, y: field.origin.y + field.height - side)
        bordersCreationMethod(botY, direction: CGPoint(x: side, y: 0), count: horizontalCount)
        
    }
    
    private func headSegment() -> GameSegment {
        let segment = GameSegment(point: headPoint, type: .Middle)
        return segment
    }
    
    private func newSegment() -> GameSegment {
        let segment = GameSegment(point: randomPoint(), type: .Food)
        
        return segment
    }
    
    private func randomPoint() -> CGPoint {
        
        func multiplier(value: CGFloat, _ coord: CGFloat) -> CGFloat {
            
            let parameter = (value - side * 2 - coord * 2).toUInt32()
            
            let side32 = side.toUInt32()
            
            var multiplier: UInt32!
            
            multiplier = arc4random_uniform(parameter / side32)
            
            if multiplier <= 0 {
                multiplier = 1
            }
            
            return CGFloat(multiplier) * side + coord
        }
        
        return CGPoint(x: multiplier(field.width, field.origin.x), y: multiplier(field.height, field.origin.y))
    }
    
    private func centerPoint() -> CGPoint {
        
        func multiplier(value: CGFloat, _ coord: CGFloat) -> CGFloat{
            
            let multiplier = value / side
            
            return floor(multiplier / 2) * side + coord
        }
        
        return CGPoint(x: multiplier(field.width, field.origin.x), y: multiplier(field.height, field.origin.y))
    }
    
    private var score: Int!
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        for segment in borders + snake {
            if segment.rect.contains(headPoint) {
                
                delegate?.snakeIsDeadWithScore(score)
                return
            }
        }
        
        moveHead()
        
        if food.rect.contains(headPoint) {
            
            score = score + 1
            
            delegate?.updateScoreWithScore(score)
            
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