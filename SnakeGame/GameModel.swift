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
        "Up" : CGPointMake(0, -10),
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
    
    var headPoint: CGPoint! {
        
        didSet{
//            print(headPoint)
        }
    }
    
    var direction: (CGPoint)!
    
    func setDefaultPosition(defaultPosition: CGPoint){
        headPoint = defaultPosition
        
        setDirection("Up")
    }
    
    func updateHead(){
        
        
        headPoint.x += direction.x
        headPoint.y += direction.y
        
    }
}
