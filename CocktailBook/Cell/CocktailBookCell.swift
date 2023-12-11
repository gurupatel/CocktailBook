//
//  CocktailBookCell.swift
//  CocktailBook
//
//  Created by Gaurang Patel on 11/12/23.
//

import UIKit

class CocktailBookCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
    }

}

