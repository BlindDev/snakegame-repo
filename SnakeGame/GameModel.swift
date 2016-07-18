//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameBrain {
    
    private var actions: Dictionary <String, (CGFloat, CGFloat)> = [
        "Up" : (-10,0),
        "Down" : (10,0),
        "Left" : (0,-10),
        "Right" : (0,10)
    ]
    
    func setDirection(buttonAction: String){
        
        if let action = actions[buttonAction] {
            direction = action
        }
    }
    
    var headPoint: CGPoint! {
        
        didSet{
            print(headPoint)
        }
    }
    var direction: (v: CGFloat, h: CGFloat)!
    
    func setDefaultPosition(defaultPosition: CGPoint){
        headPoint = defaultPosition
        
        setDirection("Up")
    }
    
    func updateHead(){
        
        headPoint.y += direction.v
        
        headPoint.x += direction.h
    }
}
