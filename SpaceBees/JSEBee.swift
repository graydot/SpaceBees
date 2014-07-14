//
//  JSEBee.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEBee:SKSpriteNode {
    init(position:CGPoint) {
        var texture = SKTexture(imageNamed: "Bee")
        var size = texture.size()
        var color = UIColor.whiteColor()

        super.init(texture: texture, color: color, size: size)
        xScale = 0.25
        yScale = 0.25
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 3

    }
}