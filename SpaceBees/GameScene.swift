//
//  GameScene.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIAlertViewDelegate {
    let spaceShip = JSEShip()
    var nodes:[SKSpriteNode] = []
    var timer:NSTimer?
    var gameStopped = false

    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        // insert space background
        let background1 = JSEBackground(position: CGPoint(x: 0, y: 0))
        self.addChild(background1)
        self.addChild(JSEBackground(position: CGPoint(x: 0, y: background1.size.height)))

        startGame()
    }
    
    func firePollens(){
        for node in nodes{
            if let bee = node as? JSEBee{
                if let bullet = bee.fireBulletTo(nil, y: frame.origin.y - 100){
                    self.addChild(bullet)
                }
            }
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            spaceShip.moveTo(location){
                let bulletPosition = CGPoint(x: self.spaceShip.position.x, y: self.spaceShip.position.y + self.spaceShip.size.height/2 ) 
                let topOfScreen = CGPointMake(self.spaceShip.position.x, (self.frame.origin.y + self.frame.size.height + 100))
                
                var bullet = JSEBullet(type: "shipBullet", startPosition: bulletPosition, endPosition: topOfScreen)
                self.addChild(bullet)
                self.nodes.append(bullet)

            }
            

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if !gameStopped{
            self.enumerateChildNodesWithName("background", usingBlock: {(node, stop) in
                var spriteNode = node as JSEBackground
                spriteNode.resetPosition()
            })
            
            var beeCount = 0
            self.enumerateChildNodesWithName("Bee", usingBlock: {(node, stop) in
                let bee = node as JSEBee
                
                if bee.alive {
                    beeCount++
                }
                })
            
            if beeCount == 0 {
                endGame()
                UIAlertView(title: "Victory", message: "You have won the Bee Wars!", delegate: self, cancelButtonTitle: "Ok!").show()
            }
            
            if !spaceShip.alive {
                endGame()
                UIAlertView(title: "Failure", message: "You underestimated the Bees. Better luck next time.", delegate: nil, cancelButtonTitle: "Ok!").show()
                
            }

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
    
    func startGame(){
        let topOffset:CGFloat = 160
        let bottomOffset:CGFloat = 40
        let xCenter = (frame.origin.x + frame.size.width)/2
        let yMid = (frame.origin.y + frame.size.height)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;
        let bottomOffsettedY = frame.origin.y + bottomOffset;
        

        
        // insert bees
        let bee1 = JSEBee(position: CGPointMake(xCenter - 100, topOffsettedY - 30))
        let bee2 = JSEBee(position: CGPointMake(xCenter + 100, topOffsettedY + 30))
        
        self.addChild(bee1)
        self.addChild(bee2)
        bee1.move()
        bee2.move()
        nodes.append(bee1)
        nodes.append(bee2)
        
        spaceShip.position = CGPoint(x: xCenter, y: bottomOffset)
        self.addChild(spaceShip)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "firePollens", userInfo: nil, repeats: true)
        gameStopped = false
    }
    func endGame(){
        
        for node in nodes{
            node.removeFromParent()
        }
        timer?.invalidate()
        spaceShip.removeFromParent()
        gameStopped = true
    }
    
    func alertView(alertView: UIAlertView!,
        didDismissWithButtonIndex buttonIndex: Int){
        startGame()
    }
    
}
