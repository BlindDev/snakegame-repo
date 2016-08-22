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
    @IBAction func refreshAction(sender: UIBarButtonItem) {
        resetBrain()
    }
    
    private var brain: GameBrain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameFieldView.delegate = self
    }
    
    @objc private func movePoint() {
        
        brain.updateHead()
        gameFieldView.renderSegments(brain.segments)
    }
    
    private func resetBrain() {
        brain = GameBrain(viewSize: gameFieldView.bounds.size)
        brain.delegate = self
        gameFieldView.renderBorders(brain.borders)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.10,  target: self, selector: #selector(movePoint), userInfo: nil, repeats: true)
    }
}

extension GameViewController: DidDrawDelegate{
    
    func viewDidDraw() {
        
        resetBrain()
    }
}

extension GameViewController: BrainDelegate {
    func snakeIsDeadWithScore(value: Int) {
        
        navigationItem.title = "Game over! Score: \(value)"

        timer.invalidate()
        timer = nil
    }
    
    func updateScoreWithScore(value: Int) {
        
        navigationItem.title = "Score: \(value)"
    }
}
