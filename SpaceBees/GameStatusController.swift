//
//  GameStatusController.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/16/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import UIKit

class GameStatusController:UIViewController{
    var delegate:GameStatusControllerDelegate?
    var level:Int = 0
    var won:Bool = false
    @IBOutlet var resultText:UILabel
    @IBOutlet var playButton:UIButton
    
    override func viewWillAppear(animated: Bool)  {
        println("Configuring View")
        if won {
            resultText.text = "You won against the bees in level \(level).\nTake it to the next level now!"
            playButton.titleLabel.text  = "Play level \(level + 1)"
        } else {
            resultText.text = "You lost against the bees.\n Fight them again!"
            playButton.titleLabel.text  = "Play level \(level) again"
        }
        resultText.sizeToFit()
        
    }
    
    @IBAction func didClickPlay(){
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.didDismiss()
    }
    
    
}