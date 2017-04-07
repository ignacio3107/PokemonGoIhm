//
//  BattleScene.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 05/04/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    var pokemonSprite : SKNode!
    var pokeballSprite : SKNode!
    
    let KPokemonSize : CGSize = CGSize(width: 50, height: 50)
    let KPokemonName : String = "pokemon"
    let kPokeballName : String = "pokeball"
    
    let pokemonDistance = 150.0
    let pokemonPixelsPerSecond = 120.0
    
    //Categorias con sistema Binario
    let KPokemonCategory : UInt32 = 0x1 << 0
    let KPokeballCategory : UInt32 = 0x1 << 1
    let KSceneEdgeCategory : UInt32 = 0x1 << 2
    
    
    var velocity : CGPoint = CGPoint.zero
    var touchPoint : CGPoint = CGPoint()
    var canThrowPokeball = false
    
    var pokemonCaught = false
    
    var startCount = true
    var maxTime = 10
    var myTime = 15
    
    var printTime = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    
    
    //Metodo que inicia una escena
    override func didMove(to view: SKView) {
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bgImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bgImage.zPosition = -1
        self.addChild(bgImage)
        
        self.printTime.position = CGPoint(x: self.size.width/2.0, y: self.size.height * 0.9)
        self.printTime.fontSize = 50
        self.addChild(self.printTime)
        
        //Muestra la imagen de batalla al comenzar la escena
        self.showMessageWith(imageNamed: "battle")
        
        
        
        //Añadimos al pokemon y la pokeball un segundo despues de visualizar la escena de la batalla
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 0.1)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 0.1)
        
        
        //Declarar que se va a utilizar física para el juego
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) //Evitarà que la pokeball se escape de la pantalla
        self.physicsBody!.categoryBitMask = KSceneEdgeCategory
        self.physicsWorld.contactDelegate = self
        
        
    }
    
    
    //Funcion que crea un objeto (nodo) pokemon
    func createPokemon() -> SKNode {
        let pokemonSprite = SKSpriteNode(imageNamed: self.pokemon.imageFileName!)
        pokemonSprite.size = KPokemonSize
        pokemonSprite.name = KPokemonName
        return pokemonSprite
    }
    
    //Función que configura el nodo pokemon
    func setupPokemon() {
        self.pokemonSprite = self.createPokemon()
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: KPokemonSize)
        self.pokemonSprite.physicsBody!.isDynamic = false //El pokemon se va a mover de acuerdo a colisiones? FALSE (Sólo de izq a der)
        self.pokemonSprite.physicsBody!.affectedByGravity = false //El pokemon NO estará afectado por la gravedad
        self.pokemonSprite.physicsBody!.mass = 1.0 //Peso del pokemon
        
        self.pokemonSprite.physicsBody!.categoryBitMask = KPokemonCategory
        self.pokemonSprite.physicsBody!.contactTestBitMask = KPokeballCategory
        self.pokemonSprite.physicsBody!.collisionBitMask = KSceneEdgeCategory
        
        //Mover pokemon de izquierda a derecha
        let moveRight = SKAction.moveBy(x: CGFloat(self.pokemonDistance), y: 0, duration: self.pokemonDistance/self.pokemonPixelsPerSecond) // Mueve de donde aparece el pokemon a la derecha en 150 pixeles y 3 segundos
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight]) // -> <- <- ->
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        
        self.addChild(self.pokemonSprite)
    }
    
    //Funcion que crea un objeto (nodo) pokeball
    func createPokeball() -> SKNode {
        let pokeballSprite = SKSpriteNode(imageNamed: "ultra-ball")
        pokeballSprite.size = KPokemonSize
        pokeballSprite.name = kPokeballName
        return pokeballSprite
    }
    
    //Función que configura el nodo pokeball
    func setupPokeball() {
        self.pokeballSprite = self.createPokeball()
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2.0)
        self.pokeballSprite.physicsBody!.isDynamic = true //La pokeball tiene que rebotar cuando colisione? TRUE
        self.pokeballSprite.physicsBody!.affectedByGravity = true //La pokeball SI estará afectado por la gravedad
        self.pokeballSprite.physicsBody!.mass = 0.1 //Peso del pokemon
        
        self.pokeballSprite.physicsBody!.categoryBitMask = KPokeballCategory
        self.pokeballSprite.physicsBody!.contactTestBitMask = KPokemonCategory
        self.pokeballSprite.physicsBody!.collisionBitMask = KSceneEdgeCategory | KPokemonCategory
        
        self.addChild(self.pokeballSprite)
    }
    
    //El usuario toca la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        if self.pokeballSprite.frame.contains(location) { // Si el toque fue en la pokeball hacer sentencias
            self.canThrowPokeball = true
            self.touchPoint = location
        }
    }
    
    //El usuario deja de tocar la pantalla
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        self.touchPoint = location
        if canThrowPokeball {
            self.throwPokeball()
        }
    }
    
    //Hacer el lanzamiento de la pokeball...
    func throwPokeball(){
        self.canThrowPokeball = false
        
        let dt: CGFloat = 1.0/4.0 //Diferencial de tiempo para saber que tan fuerte setiene que lanzar la pokeball
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
        self.pokeballSprite.physicsBody!.velocity = velocity
    
    }
    
    
    
    
    //Mètodo que se encarga de saber si dos elementos han contactado en pantalla
    func didBegin(_ contact: SKPhysicsContact) {
         let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case KPokemonCategory|KPokeballCategory:
            print("Capturado...")
            self.pokemonCaught = true
            endGame()
        default:
            return
        }
        
        
    }
    
    //Esta funciòn se ejecuta automàticamente 60 veces por segundo 60 FPS
    override func update(_ currentTime: TimeInterval) {
        if self.startCount{
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.printTime.text = "\(self.myTime)"
        if self.myTime <= 0 {
            endGame()
        }
    }
    
    func endGame() {
        self.pokemonSprite.removeFromParent()
        self.pokeballSprite.removeFromParent()
        
        if self.pokemonCaught{
            print("PokemonCapturado")
            self.pokemon.timesCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.showMessageWith(imageNamed: "gotcha")
        }else{
            print("Me he quedado sin tiempo... :(")
            self.showMessageWith(imageNamed: "footprints")
        }
        
        //Mandar la notificacion de cerrar y regresar al mapa un segundo despues de capturar al pokemon o quedarme sin tiempo.
        self.perform(#selector(endBattle), with: nil, afterDelay: 1.0)
    }
    
    func showMessageWith(imageNamed: String){
        let message = SKSpriteNode(imageNamed: imageNamed)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()])) //Se ejecuta secuencia de esperar un segundo y despues desaparecer..
    }
    
    
    //Lanza una notificación a BattleViewController
    func endBattle(){
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"), object: nil)
    }
    
    
    
    
}
