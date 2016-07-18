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
        brain.performAction(sender.currentTitle!)
        
    }
    
    private var brain = GameBrain()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        brain.setDefaultPosition(view.center)
                
    }


}
