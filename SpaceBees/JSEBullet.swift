//
//  Bullet.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEBullet:SKSpriteNode {
    var delegate:SpaceMapDelegate?
    init(type:String, var startPosition: CGPoint, endPosition: CGPoint, delegate:SpaceMapDelegate?) {
        var color:UIColor
        var size:CGSize
        var contactMask:UInt32
        
        if type == "shipBullet"{
            color = UIColor.redColor()
            size = CGSize(width: 4, height: 15)
            contactMask = 0x1 << 3
        } else {
            color = UIColor.greenColor()
            size = CGSize(width: 5, height: 4)
            contactMask = 0x1 << 4
        }
        

        super.init(texture: nil, color: color, size: size)
        self.delegate = delegate
        
        var y:CGFloat
        
        if startPosition.y > endPosition.y{
             y = startPosition.y - size.height/2
        } else {
            y = startPosition.y + size.height/2
        }
        startPosition.y = y + 1
        position = startPosition
        zPosition = 1
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = contactMask
        physicsBody.collisionBitMask = contactMask
        self.delegate?.didAddBulletToSpace(self)
        // find vector
        let shootAction = SKAction.moveTo(endPosition, duration: 2)
        runAction(shootAction)

    }
    
}