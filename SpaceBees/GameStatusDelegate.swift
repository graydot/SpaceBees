//
//  GameStatusDelegate.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/16/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation

protocol GameStatusDelegate{
    func didEndGame(level:Int, won:Bool)
}
