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
    
    var direction = "Left"
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
        zPosition = 1
        self.name = "Bee"
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 3
        physicsBody.collisionBitMask = 0
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
    
    func generateAction()->SKAction{
        
        var endPoint:CGPoint
        let fullDistance = parent.frame.size.width
        var xTarget:CGFloat
        if direction == "Left"{
            // move right
            direction = "Right"
            xTarget = parent.frame.origin.x + parent.frame.size.width - size.width/2
            
        } else {
            // move left
            direction = "Left"
            xTarget = parent.frame.origin.x + size.width/2
        }
        endPoint = CGPoint(x:xTarget, y:self.position.y)
        let xDelta = position.x - xTarget
        let duration = xDelta/fullDistance * 2
        return SKAction.moveTo(endPoint, duration: abs(duration))
    }
    
    func move(){
        
        if !alive{
            return
        }
        
        
        // create action
        // start action and call move again
        runAction(generateAction(), completion: {() in
            self.move()
        })
    }
}