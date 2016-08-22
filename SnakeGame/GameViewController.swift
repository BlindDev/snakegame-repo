//
//  GameViewController.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private var timer: NSTimer!

    @IBOutlet weak var gameFieldView: GameFieldView!
    
    @IBAction func swipeRecognizer(sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Right:
            brain.setDirection("Right")
        case UISwipeGestureRecognizerDirection.Down:
            brain.setDirection("Down")
        case UISwipeGestureRecognizerDirection.Left:
            brain.setDirection("Left")
        case UISwipeGestureRecognizerDirection.Up:
            brain.setDirection("Up")
        default:
            break
        }

    }
    
    private var brain: GameBrain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameFieldView.delegate = self
    }
    


    @objc private func movePoint() {
        
        brain.updateHead()
        updateViewHead()
    }
    
    private func updateViewHead(){
        gameFieldView.renderSegments(brain.segments)
    }
}

extension GameViewController: DidDrawDelegate{
    func viewDidDraw() {
        brain = GameBrain(viewSize: gameFieldView.correctSize)
        brain.delegate = self
        gameFieldView.renderBorders(brain.borders)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.50,  target: self, selector: #selector(movePoint), userInfo: nil, repeats: true)
    }
}

extension GameViewController: BrainDelegate {
    func snakeIsDead() {
        timer.invalidate()
        timer = nil
    }
}
