//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

let side = round(UIScreen.main.bounds.width / 20)

protocol BrainDelegate {
    func snakeIsDeadWithScore(_ value: Int)
    func updateScoreWithScore(_ value: Int)
}

class GameBrain {
    
    var delegate: BrainDelegate?
    
    fileprivate var direction: (CGPoint)!
    
    func setDirection(_ gestureDirection: UISwipeGestureRecognizerDirection){
        
        var newDirection: CGPoint!
        
        switch gestureDirection {
        case UISwipeGestureRecognizerDirection.right:
            newDirection = CGPoint(x: side,y: 0)
        case UISwipeGestureRecognizerDirection.down:
            newDirection = CGPoint(x: 0,y: side)
        case UISwipeGestureRecognizerDirection.left:
            newDirection = CGPoint(x: -side,y: 0)
        case UISwipeGestureRecognizerDirection.up:
            newDirection = CGPoint(x: 0,y: -side)
        default:
            break
        }
        
        if direction == nil || !(direction.x + newDirection.x == 0 && direction.y + newDirection.y == 0) {
            direction = newDirection
        }
    }
    
    fileprivate var headPoint: CGPoint!
    
    fileprivate var field: CGRect!
    
    fileprivate var borders: [GameSegment]!
    
    fileprivate var snake: [GameSegment]!
    
    fileprivate var food: GameSegment!
    
    var segments: [GameSegment]! {
        get{
            var array = snake + borders
            
            if food != nil {
                array.append(food)
            }
            
            return array
        }
    }
    
    init(viewSize: CGSize) {
        
        let x = (viewSize.width.truncatingRemainder(dividingBy: side))
        
        let y = (viewSize.height.truncatingRemainder(dividingBy: side))
        
        field = CGRect(x: x/2, y: y/2, width: viewSize.width - x, height: viewSize.height - y)
        
        score = 0
        
        //prepareView
        borders = []
        createBorders()
        
        //setting default direction
        setDirection(UISwipeGestureRecognizerDirection.up)
        
        headPoint = centerPoint()
        //snake body
        snake = []
        snake.append(headSegment())
        snake.append(headSegment())
        
        //create segment to eat
        food = newSegment(.food)
    }
    
    fileprivate func createBorders(){
        
        func bordersCreationMethod(_ startP: CGPoint, direction: CGPoint, count: Int) {
            
            let startBorder = GameSegment(point: startP, type: .border)
            borders.append(startBorder)
            
            var cyclePoint = startP
            for _ in 1..<count {
                let borderPoint = CGPoint(x: cyclePoint.x + direction.x, y: cyclePoint.y + direction.y)
                let newBorder = GameSegment(point: borderPoint, type: .border)
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
    
    fileprivate func headSegment() -> GameSegment {
        let segment = GameSegment(point: headPoint, type: .middle)
        return segment
    }
    
    fileprivate func newSegment(_ type: SegmentType) -> GameSegment {
        
        let segment = GameSegment(point: randomPoint(), type: type)
        
        return segment
    }
    
    fileprivate func randomPoint() -> CGPoint {
        
        func multiplier(_ value: CGFloat, _ coord: CGFloat) -> CGFloat {
            
            let parameter = (value - side * 2 - coord * 2).toUInt32()
            
            let side32 = side.toUInt32()
            
            var multiplier: UInt32!
            
            multiplier = arc4random_uniform(parameter / side32)
            
            if multiplier <= 0 {
                multiplier = 1
            }
            
            return CGFloat(multiplier) * side + coord
        }
        
        let newPoint = CGPoint(x: multiplier(field.width, field.origin.x), y: multiplier(field.height, field.origin.y))
        
        for segment in segments {
            
            if segment.rect.contains(newPoint) {
                return randomPoint()
            }
        }
        
        return newPoint
    }
    
    fileprivate func centerPoint() -> CGPoint {
        
        func multiplier(_ value: CGFloat, _ coord: CGFloat) -> CGFloat{
            
            let multiplier = value / side
            
            return floor(multiplier / 2) * side + coord
        }
        
        return CGPoint(x: multiplier(field.width, field.origin.x), y: multiplier(field.height, field.origin.y))
    }
    
    fileprivate var score: Int! {
        didSet{
            if score % 3 == 0 {
                borders.append(newSegment(.border))
            }
        }
    }
    
    func updateHead(){
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
        for segment in borders + snake {
            if segment.rect.contains(headPoint) {
                
                delegate?.snakeIsDeadWithScore(score)
                return
            }
        }
        
        if food.rect.contains(headPoint) {
                        
            score = score + 1
            
            delegate?.updateScoreWithScore(score)
            
            snake.insert(food, at: snake.endIndex)
            
            food = newSegment(.food)
        }
        
        moveHead()
    }
    
    fileprivate func directionByPoint(_ current: CGPoint, next: CGPoint) -> Direction {
        
        var newDirection: Direction = .up
        
        if next.x - current.x > 0 {
            newDirection = Direction.right
        }
        
        if next.x - current.x < 0 {
            newDirection = Direction.left
        }
        
        if next.y - current.y > 0 {
            newDirection = Direction.down
        }
        
        if next.y - current.y < 0 {
            newDirection = Direction.up
        }
        
        return newDirection
    }
    
    fileprivate func moveHead() {
        
        guard let first = snake.first else{
            return
        }
        
        first.type = SegmentType.middle
        
        let head = headSegment()
        head.type = SegmentType.head
        head.direction = directionByPoint(first.rect.origin, next: headPoint)

        snake.insert(head, at: 0)
        
        snake.removeLast()
        
        guard let last = snake.last else{
            return
        }
        
        last.type = SegmentType.tail
        
        let tailPrevous = snake[snake.endIndex - 2]
        
        last.direction = directionByPoint(last.rect.origin, next: tailPrevous.rect.origin)
    }
    
}

extension CGFloat{
    
    func toUInt32() -> UInt32 {
        return UInt32(self)
    }
}
