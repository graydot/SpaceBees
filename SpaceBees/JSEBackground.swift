//
//  JSEBackground.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/14/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEBackground:SKSpriteNode{
    init(position:CGPoint){
        var texture = SKTexture(imageNamed: "SpaceBackground")
        super.init(texture: texture, color: UIColor.blackColor(), size: texture.size())
        anchorPoint = CGPointZero
        self.position = position
        name = "background"
    }
}
