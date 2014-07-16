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
    let topOffset:CGFloat = 20
    var spaceShip:JSEShip = JSEShip()
    var bees: [JSEBee] = []
    var bullets: [JSEBullet] = []
    var background:JSEBackground = JSEBackground()
    var gameStopped = false
    var level = 0
    var gameDelegate:GameStatusDelegate?

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
        
        for node in [nodeA, nodeB]{
            if let bee = node as? JSEBee{
                bee.runAction(fadeAnimation, completion: {() in
                    bee.removeFromParent()
                })
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
            } else if let ship = node as? JSEShip{
                ship.destroyed = true
            } else {
                node.removeFromParent()
            }
            
        }
        

        checkGameStatus()
    }
    
    
    func checkGameStatus(){
        
        if bees.count == 0 || spaceShip.destroyed{
            var won:Bool = false
            if bees.count == 0 {
//                UIAlertView(title: "Victory", message: "You have won the Bee Wars!", delegate: self, cancelButtonTitle: "Ok!").show()
                won = true
                level++
                endGame()
            } else if spaceShip.destroyed {
//                UIAlertView(title: "Failure", message: "You underestimated the Bees. Better luck next time.", delegate: self, cancelButtonTitle: "Ok!").show()
                won = false
                endGame()
            }
            self.gameDelegate?.didEndGame(level,won: won)
        }
        
        
        

    }
    
    func startGame(){
        let bottomOffset:CGFloat = 40
        let xCenter = (frame.origin.x + frame.size.width)/2
        let yMid = (frame.origin.y + frame.size.height)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;
        let bottomOffsettedY = frame.origin.y + bottomOffset;
        
        generateBees()
        
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

        spaceShip.destroyed = true
        spaceShip.removeFromParent()
        
        for bullet in bullets{
            bullet.removeFromParent()
        }

    }
    
    func generateBees(){
        let xCenter = (frame.origin.x + frame.size.width)/2
        let topOffsettedY = frame.origin.y + frame.size.height - topOffset;

        let beesCount = level + 2
        bees = []
        for (var i=0; i<beesCount; i++){
            var beeOffsetY = size.height - topOffset - CGFloat(i * 50) // bee size
            // randomize x position
            var beeOffsetX = CGFloat(random()) % (frame.width)
            JSEBee(position: CGPointMake(beeOffsetX, beeOffsetY), delegate:self)
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
