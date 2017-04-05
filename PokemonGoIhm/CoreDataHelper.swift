//
//  CoreDataHelper.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 30/03/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import UIKit
import CoreData

func createAllThePokemons(){
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    createPokemon(name: "Abra", with: "abra")
    createPokemon(name: "Bellsprout", with: "bellsprout")
    createPokemon(name: "Bullbasaur", with: "bullbasaur")
    createPokemon(name: "Caterpie", with: "caterpie")
    createPokemon(name: "Charmander", with: "charmander")
    createPokemon(name: "Dratini", with: "dratini")
    createPokemon(name: "Eevee", with: "eevee")
    createPokemon(name: "Jigglypuff", with: "jigglypuff")
    createPokemon(name: "Mankey", with: "mankey")
    createPokemon(name: "Meowth", with: "meowth")
    createPokemon(name: "Mew", with: "mew")
    createPokemon(name: "Pidgey", with: "pidgey")
    createPokemon(name: "Pikachu", with: "pikachu-2")
    createPokemon(name: "Psyduck", with: "psyduck")
    createPokemon(name: "Rattata", with: "rattata")
    createPokemon(name: "Squirtle", with: "squirtle")
    createPokemon(name: "Snorlax", with: "snorlax")
    createPokemon(name: "Zubat", with: "zubat")
    createPokemon(name: "Venonat", with: "venonat")
    createPokemon(name: "Weedle", with: "weedle")
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()

}


func createPokemon(name:String, with imageNamed:String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
}

/*func createAndCaughtPokemon(name:String, with imageNamed:String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.timesCaught = 1
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}*/



func getAllThePokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let pokemons =  try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            createAllThePokemons()
            return getAllThePokemons()
        }
        return pokemons
    }catch{
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}


func getAllCaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)  // Instrucción que busca el campo timesCaught en CoreData mayor a 0
    
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch{
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}


func getAllUncaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)  // Instrucción que busca el campo timesCaught en CoreData mayor a 0
    
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch{
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}




