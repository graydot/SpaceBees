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
    let reloadTime = Int(arc4random()) % 5 + 1
    var alive = true
    var reloadTimer = 0
    init(position:CGPoint) {
        var texture = SKTexture(imageNamed: "Bee")
        var size = texture.size()
        var color = UIColor.whiteColor()

        super.init(texture: texture, color: color, size: size)
        xScale = 0.20
        yScale = 0.20
        self.position = position
        self.name = "Bee"
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 3

    }
    
    func fireBulletTo(x:CGFloat?, y:CGFloat?) -> SKSpriteNode?{
        if alive && canFire(){
            let bulletPosition = CGPoint(x: position.x, y: position.y - size.height/2 )
            var endPoint = position
            if let xValue = x{
                endPoint.x = xValue
            }
            
            if let yValue = y{
                endPoint.y = yValue
            }
            
            return JSEBullet(type: "pollenBullet", startPosition: bulletPosition, endPosition: endPoint)
            
        }
        return nil
    }
    
    func canFire()-> Bool{
        if reloadTimer == 0 {
            // I can fire
            
            reloadTimer = reloadTime
            return true
            
        } else {
            reloadTimer -= 1
            return false
        }
    }
}