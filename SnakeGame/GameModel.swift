//
//  GameModel.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class GameBrain {
    
    private var actions: Dictionary <String, Action> = [
        "Up" : Action.Up,
        "Down" : Action.Down,
        "Left" : Action.Left,
        "Right" : Action.Rigth
    ]
    
    private enum Action {
        case Up
        case Down
        case Left
        case Rigth
    }
    
    func performAction(buttonAction: String){
        
        if let action = actions[buttonAction] {
            switch action {
            case .Up:
                goUp()
            case .Down:
                goDown()
            case .Left:
                goLeft()
            case .Rigth:
                goRight()
            }
        }
    }
    
    private func goUp(){
        print("Up")
    }
    
    private func goDown(){
        print("Down")

    }
    
    private func goLeft(){
        print("Left")

    }
    
    private func goRight(){
        print("Right")

    }
}
