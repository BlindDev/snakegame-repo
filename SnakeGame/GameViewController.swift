//
//  GameViewController.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    fileprivate var timer: Timer!

    @IBOutlet weak var gameFieldView: GameFieldView!
    
    @IBAction func swipeRecognizer(_ sender: UISwipeGestureRecognizer) {
        
        brain.setDirection(sender.direction)
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        
        gameFieldView.clearSubviews()
        resetBrain()
    }
    
    fileprivate var brain: GameBrain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameFieldView.delegate = self
    }
    
    @objc fileprivate func movePoint() {
        
        brain.updateHead()
        gameFieldView.renderSegments(brain.segments)
    }
    
    fileprivate func resetBrain() {
        
        navigationItem.title = "Snake"

        brain = GameBrain(viewSize: gameFieldView.bounds.size)
        
        brain.delegate = self
                
        timer = Timer.scheduledTimer(timeInterval: 0.20,  target: self, selector: #selector(movePoint), userInfo: nil, repeats: true)
    }
}

extension GameViewController: DidDrawDelegate{
    
    func viewDidDraw() {
        
        resetBrain()
    }
}

extension GameViewController: BrainDelegate {
    func snakeIsDeadWithScore(_ value: Int) {
        
        navigationItem.title = "Game over! Score: \(value)"

        timer.invalidate()
        timer = nil
    }
    
    func updateScoreWithScore(_ value: Int) {
        
        navigationItem.title = "Score: \(value)"
    }
}
