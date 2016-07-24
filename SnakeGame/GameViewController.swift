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
        gameFieldView.renderBorders(brain.borders)
        
        NSTimer.scheduledTimerWithTimeInterval(0.50,  target: self, selector: #selector(movePoint), userInfo: nil, repeats: true)
    }
}
