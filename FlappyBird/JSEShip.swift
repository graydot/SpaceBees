//
//  JSEShip.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEShip:SKSpriteNode {
    init() {
        var texture = SKTexture(imageNamed: "Spaceship")
        var size = texture.size()
        var color = UIColor.blackColor()
        
        super.init(texture: texture, color: color, size: size)
        

        xScale = 0.2
        yScale = 0.2
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 4
        
    }
    
    func moveTo(location: CGPoint, closure: (()->Void)){
        let xDelta = location.x - position.x
        let yDelta = location.y - position.y
        
        // move spaceship to the location
        let vector = CGVectorMake(xDelta, 0)
        let moveAction = SKAction.moveBy(vector, duration: 0.25)
        
        runAction(moveAction, completion: {closure()})
    }

}
