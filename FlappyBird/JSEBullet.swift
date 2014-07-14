//
//  Bullet.swift
//  FlappyBird
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEBullet:SKSpriteNode {
    init(type:String, var startPosition: CGPoint, endPosition: CGPoint) {
        var color:UIColor
        var size:CGSize
        var contactMask:UInt32
        
        if type == "shipBullet"{
            color = UIColor.redColor()
            size = CGSize(width: 10, height: 30)
            contactMask = 0x1 << 3
        } else {
            color = UIColor.yellowColor()
            size = CGSize(width: 10, height: 10)
            contactMask = 0x1 << 4
        }
        

        super.init(texture: nil, color: color, size: size)
        
        var y:CGFloat
        
        if startPosition.y > endPosition.y{
             y = startPosition.y - size.height/2
        } else {
            y = startPosition.y + size.height/2
        }
        startPosition.y = y + 1
        position = startPosition
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = contactMask

        
        let shootAction = SKAction.moveTo(endPosition, duration: 2)
        runAction(shootAction)

    }
    
}