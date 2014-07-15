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
        zPosition = 0
        name = "background"
    }
    
    func resetPosition(){
        position.y = position.y - 3
        let bgTopY = position.y + size.height
        if bgTopY < 0 {
            position.y = size.height + bgTopY
        }

    }
}
