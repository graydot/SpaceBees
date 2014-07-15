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
    var destroyed = false
    var delegate:SpaceMapDelegate?
    init() {
        var texture = SKTexture(imageNamed: "Spaceship")
        var size = texture.size()
        var color = UIColor.blackColor()

        
        super.init(texture: texture, color: color, size: size)

        xScale = 0.1
        yScale = 0.1
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 4
    }
    
    func moveTo(location: CGPoint) {
        let xDelta = location.x - position.x
        let yDelta = location.y - position.y
        
        // move spaceship to the location
        let vector = CGVectorMake(xDelta, 0)
        let moveAction = SKAction.moveBy(vector, duration: 0.25)
        
        runAction(moveAction, completion: {() in
            let bulletPosition = CGPoint(x: self.position.x, y: self.position.y + self.size.height/2 )
            let endPosition = CGPoint(x:bulletPosition.x, y:self.delegate!.getSpaceFrame().height + 100)
            var bullet = JSEBullet(type: "shipBullet", startPosition: bulletPosition, endPosition:endPosition, delegate:self.delegate)
        })
    }

}
