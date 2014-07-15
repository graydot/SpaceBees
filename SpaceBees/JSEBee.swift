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
    let reloadTime = NSTimeInterval(arc4random()) % 5 + 1
    var timer:NSTimer?
    
    var direction = "Left"
    var alive:Bool = true {
    willSet(newAlive){
        if !newAlive {
            timer?.invalidate()
        }
    }
    }
    var delegate:SpaceMapDelegate?
    
    init(position:CGPoint, delegate:SpaceMapDelegate) {
        var texture = SKTexture(imageNamed: "Bee")
        var size = texture.size()
        var color = UIColor.whiteColor()

        super.init(texture: texture, color: color, size: size)
        self.delegate = delegate
        xScale = 0.1
        yScale = 0.1
        self.position = position
        zPosition = 1
        self.name = "Bee"
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = 0x1 << 3
        physicsBody.collisionBitMask = 0
        
        self.delegate?.didAddBeeToSpace(self)
        move()
        timer = NSTimer.scheduledTimerWithTimeInterval(reloadTime, target: self, selector: "fireBullet", userInfo: nil, repeats: true)

    }
    
    func fireBullet(){
        if !alive {
            return
        }
        let bulletPosition = CGPoint(x: position.x, y: position.y - size.height/2 )
        var endPoint = position
        endPoint.y = -100
        let bullet = JSEBullet(type: "pollenBullet", startPosition: bulletPosition, endPosition: endPoint, delegate: self.delegate)
    }
    
    func setAlive(newAlive:Bool){
        print("here")
        self.alive = newAlive
        
        if newAlive == false{
            timer?.invalidate()
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
        
        
        runAction(generateAction(), completion: {() in
            self.move()
        })
    }
    
    deinit{
        print("going out")
    }
    
}