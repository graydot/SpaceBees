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
    var bees:[JSEBee] = []
    var gameEnded = false
    var spriteRotateState:Float = Float(M_PI/2) // you could use the node's zRotation
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let frame = self.frame
        let topOffset:CGFloat = 160
        let bottomOffset:CGFloat = 40
        let xCenter = (frame.origin.x + frame.size.width)/2
        let yMid = (frame.origin.y + frame.size.height)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;
        let bottomOffsettedY = frame.origin.y + bottomOffset;
        
        // insert space background
        let background1 = JSEBackground(position: CGPoint(x: 0, y: 0))
        self.addChild(background1)
        self.addChild(JSEBackground(position: CGPoint(x: 0, y: background1.size.height)))
        

        // insert bees
        let bee1 = JSEBee(position: CGPointMake(xCenter - 100, topOffsettedY - 30))
        let bee2 = JSEBee(position: CGPointMake(xCenter + 100, topOffsettedY + 30))
        
        self.addChild(bee1)
        self.addChild(bee2)
        bees.append(bee1)
        bees.append(bee2)

        spaceShip.position = CGPoint(x: xCenter, y: bottomOffset)
        self.addChild(spaceShip)

        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "firePollens", userInfo: nil, repeats: true)
        
        
    }
    
    func firePollens(){
        if gameEnded{
            return
        }
        for bee in bees{
            if let bullet = bee.fireBulletTo(nil, y: frame.origin.y - 100){
                self.addChild(bullet)
            }
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameEnded{
            return
        }
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
        if gameEnded{
            return
        }
        self.enumerateChildNodesWithName("background", usingBlock: {(node, stop) in
            var spriteNode = node as SKSpriteNode
//            
            spriteNode.position.y = spriteNode.position.y - 3
            let bgTopY = spriteNode.position.y + spriteNode.size.height
            if bgTopY < 0 {
                spriteNode.position.y = spriteNode.size.height + bgTopY
            }
        })
        
        var beeCount = 0
        self.enumerateChildNodesWithName("Bee", usingBlock: {(node, stop) in
            let bee = node as JSEBee
            
            if bee.alive {
                beeCount++
            }
        })

        if beeCount == 0 {
            UIAlertView(title: "Victory", message: "You have won the Bee Wars!", delegate: nil, cancelButtonTitle: "Ok!").show()
            gameEnded = true
        }
        
        if !spaceShip.alive {
            UIAlertView(title: "Failure", message: "You underestimated the Bees. Better luck next time.", delegate: nil, cancelButtonTitle: "Ok!").show()
            gameEnded = true
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        let fadeAnimation = SKAction.fadeOutWithDuration(0.5)
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        nodeA.runAction(fadeAnimation, completion: {() in
            nodeA.removeFromParent()
            if let bee = nodeA as? JSEBee{
                bee.alive = false
            } else if let ship = nodeA as? JSEShip{
                ship.alive = false
            }
        })
        nodeB.removeFromParent()
        
        
        
    }
    
}
