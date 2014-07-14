//
//  GameScene.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let spaceShip = JSEShip()
    var bullets:[SKSpriteNode] = []
    var spriteRotateState:Float = Float(M_PI/2) // you could use the node's zRotation
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let frame = self.frame
        let topOffset:Float = 160
        let bottomOffset:Float = 40
        let xCenter = (frame.origin.x + frame.size.width)/2
        let yMid = (frame.origin.y + frame.size.height)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;
        let bottomOffsettedY = frame.origin.y + bottomOffset;

        // insert bees
        let bee1 = JSEBee(position: CGPointMake(xCenter - 100, topOffsettedY))
        let bee2 = JSEBee(position: CGPointMake(xCenter + 100, topOffsettedY))
        
        self.addChild(bee1)
        self.addChild(bee2)

        spaceShip.position = CGPoint(x: xCenter, y: bottomOffset)
        self.addChild(spaceShip)

        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "firePollens", userInfo: nil, repeats: true)
        
        
    }
    
    func firePollens(){
        
//        let startPosition = CGPoint(x: self.spaceShip.position.x, y: self.spaceShip.position.y + self.spaceShip.size.height/2) // + bullet.size.height/2 + 1)
//        let endPosition = CGPointMake(self.spaceShip.position.x, (self.frame.origin.y + self.frame.size.height + 100))
//
//        
//        var bullet = JSEBullet(type: "pollenBullet", startPosition: startPosition, endPosition: endPosition)
//        self.addChild(bullet)
//        self.bullets.append(bullet)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            spaceShip.moveTo(location){
                let bulletPosition = CGPoint(x: self.spaceShip.position.x, y: self.spaceShip.position.y + self.spaceShip.size.height/2 ) 
                let topOfScreen = CGPointMake(self.spaceShip.position.x, (self.frame.origin.y + self.frame.size.height + 100))
                
                var bullet = JSEBullet(type: "shipBullet", startPosition: bulletPosition, endPosition: topOfScreen)
                self.addChild(bullet)
                self.bullets.append(bullet)

            }
            

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        let fadeAnimation = SKAction.fadeOutWithDuration(0.5)
        
        contact.bodyA.node.runAction(fadeAnimation, completion: {() in
            contact.bodyA.node.removeFromParent()
        })
        contact.bodyB.node.removeFromParent()
    }
}
