//
//  CocktailBookModel.swift
//  CocktailBook
//
//  Created by Gaurang Patel on 11/12/23.
//

import Foundation

class CocktailBookModel : Decodable {
    var id : String? = nil
    var imageName : String? = nil
    var name : String? = nil
    var longDescription : String? = nil
    var shortDescription : String? = nil
    var type : String? = nil
    var preparationMinutes : Int? = nil
    var ingredients : [String]? = nil
    var favourite : Bool? = nil
}

