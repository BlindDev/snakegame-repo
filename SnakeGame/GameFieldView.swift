//
//  GameFieldView.swift
//  SnakeGame
//
//  Created by Pavel Popov on 18.07.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

class GameFieldView: UIView {
    
    private var head: UIView!

    func createHead() {
        
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        head = UIView(frame: frame)
        head.backgroundColor = UIColor.greenColor()
        addSubview(head)
    }
    
    func renderHead(position: CGPoint) {
        
        head.center = position
    }
}
