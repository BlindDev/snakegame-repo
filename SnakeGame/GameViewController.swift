//
//  GameViewController.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameFieldView: GameFieldView!
    
    @IBAction func buttonAction(sender: UIButton) {
        brain.setDirection(sender.currentTitle!)
    }
    
    private var brain = GameBrain()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        gameFieldView.setNeedsLayout()
        gameFieldView.layoutIfNeeded()
        brain.setDefaultPosition(view.center, viewSize: gameFieldView.correctSize)
        
        NSTimer.scheduledTimerWithTimeInterval(1.00,  target: self, selector: #selector(movePoint), userInfo: nil, repeats: true)
    }


    @objc private func movePoint() {
        
        brain.updateHead()
        updateViewHead()
    }
    
    private func updateViewHead(){
        gameFieldView.renderSegments(brain.segments)
    }
}
