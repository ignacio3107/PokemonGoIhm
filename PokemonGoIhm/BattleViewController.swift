//
//  BattleViewController.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 05/04/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var pokemon : Pokemon!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instanciar escena y asignarle los tamaños para presentarla
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        //Mostrar la escena en nuestra vista pero convirtiendola a una SKView
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false // El tipo de renderizado debe ser muy estricto o no
        
        scene.scaleMode = .aspectFill
        scene.pokemon = self.pokemon
        skView.presentScene(scene)
        
        
        
        
        //Sirve para que BattleViewController estè constantemente observando si alguien manda una notificación con el nombre "closeBattle"
        NotificationCenter.default.addObserver(self, selector: #selector(returnToMapViewController), name: NSNotification.Name("closeBattle"), object: nil)
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func returnToMapViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
