//
//  GameScene.swift
//  FlappyBird
//
//  Created by Yihang on 2/27/16.
//  Copyright (c) 2016 Yihang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var pipeMoveAndRemove = SKAction()
    
    let pipeGap = 150.0
    
    var gameStarted = Bool()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -20.0)
        
        //Bird
        let BirdTxture = SKTexture(imageNamed: "bird")
        BirdTxture.filteringMode = SKTextureFilteringMode.Nearest
        
        bird = SKSpriteNode(texture: BirdTxture)
        bird.setScale(1.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2.0)
        bird.physicsBody?.dynamic = true;
        bird.physicsBody?.allowsRotation = false;
        bird.physicsBody?.affectedByGravity = false;
        
        self.addChild(bird)
        
        //Gound
        let groundTexture = SKTexture(imageNamed: "ground")
        
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPointMake(self.size.width/2, sprite.size.height/2)
        self.addChild(sprite)
        
        let ground = SKNode()
        
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        
        ground.physicsBody?.dynamic = false;
        self.addChild(ground)
        
        //Pipes
        
        //Create the Pipes
        pipeUpTexture = SKTexture (imageNamed: "tubeUp")
        pipeDownTexture = SKTexture(imageNamed: "tubeDown")
        
        //Movement of pipes

        
        //Spawn pipes
        
    }
    
    func spawnPipes() {
    
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(1.2)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false;
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(1.2)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false;
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(pipeMoveAndRemove)
        self.addChild(pipePair)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
       /* Called when a touch begins */
        
        if gameStarted == false{
            
            gameStarted = true
            
            bird.physicsBody?.affectedByGravity = true;

            let spawn = SKAction.runBlock({
                () in
                    
                self.spawnPipes()
            })
            let delay = SKAction.waitForDuration(NSTimeInterval(2))
            let spawnThenDelay = SKAction.sequence([spawn,delay])
            let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
            self.runAction(spawnThenDelayForever)
                
            let distanceToMove = CGFloat(self.frame.width + 2.0 * pipeUpTexture.size().width)
            let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
            let removePipes = SKAction.removeFromParent()
            pipeMoveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 25))
                
        }else{
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 25))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}