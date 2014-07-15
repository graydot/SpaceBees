//
//  GameScene.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/12/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import SpriteKit

protocol SpaceMapDelegate{
    var spaceShip:JSEShip {get set}
    var bees:[JSEBee] {get set}
    var bullets: [JSEBullet] {get set}
    var background:JSEBackground {get set}
    func didAddNodeToSpace(node:SKSpriteNode)
    func didAddBulletToSpace(bullet:JSEBullet)
    func didAddBeeToSpace(bee:JSEBee)
    func getSpaceFrame()->CGRect
}

class GameScene: SKScene, SKPhysicsContactDelegate, UIAlertViewDelegate, SpaceMapDelegate {
    var spaceShip:JSEShip = JSEShip()
    var bees: [JSEBee] = []
    var bullets: [JSEBullet] = []
    var background:JSEBackground = JSEBackground()
    var gameStopped = false

    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        spaceShip.delegate = self
        background.delegate = self
        background.addBackgroundToSpace()

        startGame()
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            spaceShip.moveTo(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStopped {
            return
        }
        
        background.scroll()
    }
    
    func didEndContact(contact: SKPhysicsContact!) {
        let fadeAnimation = SKAction.fadeOutWithDuration(0.5)
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        nodeA.runAction(fadeAnimation, completion: {() in
            nodeA.removeFromParent()
        })
        nodeB.removeFromParent()
        
        if let bee = nodeA as? JSEBee{
            bee.alive = false
            // find bee
            
            var index:Int?
            for(var i=0; i<self.bees.count; i++){
                if bee.isEqual(self.bees[i]){
                    index = i
                }
            }
            
            if index{
                self.bees.removeAtIndex(index!)
            }
        } else if let ship = nodeA as? JSEShip{
            ship.destroyed = true
        }

        checkGameStatus()
    }
    
    
    func checkGameStatus(){
        if bees.count == 0 {
            UIAlertView(title: "Victory", message: "You have won the Bee Wars!", delegate: self, cancelButtonTitle: "Ok!").show()
            endGame()
        } else if spaceShip.destroyed {
            UIAlertView(title: "Failure", message: "You underestimated the Bees. Better luck next time.", delegate: self, cancelButtonTitle: "Ok!").show()
            endGame()
        }
        

    }
    
    func startGame(){
        let topOffset:CGFloat = 160
        let bottomOffset:CGFloat = 40
        let xCenter = (frame.origin.x + frame.size.width)/2
        let yMid = (frame.origin.y + frame.size.height)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;
        let bottomOffsettedY = frame.origin.y + bottomOffset;
        

        
        // insert bees
        let bee1 = JSEBee(position: CGPointMake(xCenter - 100, topOffsettedY - 30), delegate:self)
        let bee2 = JSEBee(position: CGPointMake(xCenter + 100, topOffsettedY + 30), delegate:self)
        
        spaceShip.position = CGPoint(x: xCenter, y: bottomOffset)
        spaceShip.destroyed = false
        addChild(spaceShip)
        
        gameStopped = false
    }
    func endGame(){
        gameStopped = true
        for bee in bees{
            bee.alive = false
            bee.removeFromParent()
        }
        if !spaceShip.destroyed{
            spaceShip.destroyed = true
            spaceShip.removeFromParent()
        }
        
        for bullet in bullets{
            bullet.removeFromParent()
        }

    }
    
    func alertView(alertView: UIAlertView!,
        didDismissWithButtonIndex buttonIndex: Int){
        startGame()
    }
    
    func didAddBulletToSpace(bullet: JSEBullet) {
        self.addChild(bullet)
        bullets.append(bullet)
    }
    
    func didAddBeeToSpace(bee: JSEBee) {
        self.addChild(bee)
        bees.append(bee)
    }
    
    func didAddNodeToSpace(node:SKSpriteNode){
        self.addChild(node)
    }
    
    func getSpaceFrame() -> CGRect {
        return self.frame
    }
    
}
