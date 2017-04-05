//
//  PokemonTableViewCell.swift
//  PokemonGoIhm
//
//  Created by Desarrollo on 30/03/17.
//  Copyright © 2017 Ignacio. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    
    @IBOutlet var pokemonImageView: UIImageView!
    
    @IBOutlet var pokemonNameLabel: UILabel!
    
    @IBOutlet var pokemonTimesCaughtLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
