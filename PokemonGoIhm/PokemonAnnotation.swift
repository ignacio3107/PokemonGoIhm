//
//  PokemonAnnotation.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 31/03/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate : CLLocationCoordinate2D, pokemon : Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }

}
