//
//  CocktailBookModel.swift
//  CocktailBook
//
//  Created by Gaurang Patel on 11/12/23.
//

import Foundation

class CocktailBookModel : Decodable {
    var id : String? = ""
    var imageName : String? = ""
    var name : String? = ""
    var longDescription : String? = ""
    var shortDescription : String? = ""
    var type : String? = ""
    var preparationMinutes : Int? = 0
    var ingredients : [String]? = nil
    var favourite : Bool? = false
}

