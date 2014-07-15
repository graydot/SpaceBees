//
//  JSEBackground.swift
//  SpaceBees
//
//  Created by Jeba Singh Emmanuel on 7/14/14.
//  Copyright (c) 2014 Jeba Singh Emmanuel. All rights reserved.
//

import Foundation
import SpriteKit

class JSEBackground:NSObject{
    var backgrounds:[SKSpriteNode] = []
    var delegate:SpaceMapDelegate?
    init(){
        
        // insert space background
        var texture = SKTexture(imageNamed: "SpaceBackground2")
        var background = SKSpriteNode(texture: texture, color: UIColor.blackColor(), size: texture.size())
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
//        background.zPosition = 0
        background.name = "Background"
        backgrounds.append(background)
        delegate?.didAddNodeToSpace(background)
        
        background = SKSpriteNode(texture: texture, color: UIColor.blackColor(), size: texture.size())
        background.anchorPoint = CGPointZero
        background.position = CGPoint(x: CGPointZero.x, y: CGPointZero.y + texture.size().height)
        background.name = "Background"
        backgrounds.append(background)
        delegate?.didAddNodeToSpace(background)
    }
    
    // yeah this is crappy
    func addBackgroundToSpace(){
        for bg in backgrounds{
            delegate?.didAddNodeToSpace(bg)
        }
    }
    
    func scroll(){
        for bg in backgrounds{
            bg.position.y = bg.position.y - 3
            let bgTopY = bg.position.y + bg.size.height
            if bgTopY < 0 {
                bg.position.y = bg.size.height + bgTopY
            }

        }
    }
}
