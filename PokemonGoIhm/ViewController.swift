//
//  ViewController.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 30/03/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    let mapDistance : CLLocationDistance = 300
    
    let captureDistance : CLLocationDistance = 150
    
    var pokemonSpawnTimer : TimeInterval = 9
    
    var pokemons : [Pokemon] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        self.pokemons = getAllThePokemons()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //print("Estamos listos para salir a cazar pokemons...!!")
            
            self.mapView.delegate = self  //Delegado para poder cambiar la imagen de la chincheta por un poke
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: pokemonSpawnTimer, repeats: true, block: { (timer) in
                //Hay que generar un nuevo pokemon..
                //print("Se generó un nuevo pokemon")
                
                if let coordinate = self.manager.location?.coordinate {
                    
                    let randomPos = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                    let pokemon = self.pokemons[randomPos]
                    
                    let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                    annotation.coordinate = coordinate
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0)/100000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0)/100000.0
                    
                    self.mapView.addAnnotation(annotation)
                }
            })
        }else{
            self.manager.requestWhenInUseAuthorization()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Core Location Manager Delegate
    
    // Se manda llamar cada vez que el usuario se mueve un poco
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 4 {
            if let coordinate = self.manager.location?.coordinate{
                let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
                self.mapView.setRegion(region, animated: true)
                updateCount += 1
            }
        } else{
            self.manager.stopUpdatingLocation()
        }
    }
    
    
    //MARK:  MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation{
            annotationView.image = #imageLiteral(resourceName: "player")
        }else{
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            //annotationView.image = #imageLiteral(resourceName: "squirtle")
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 35
        newFrame.size.width = 35
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: false) //Seleccionar el mismo pokemon varias veces
        
        if view.annotation! is MKUserLocation{
            return
        }
        
        print("Se ha seleccionado un pokemon..")
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        self.mapView.setRegion(region, animated: true)
        
        if let coordinate = self.manager.location?.coordinate{
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) { //Determina si la zona visible de un mapa contiene o no contiene un punto
                print("Podemos capturar el pokemon")
            }else{
                print("Demasiado lejos para cazar el pokemon")
            }
        }
        
        
        
    }
    

    
    
    
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        if let coordinate = self.manager.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool{
         return true
    }

}

