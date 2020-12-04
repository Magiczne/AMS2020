//
//  Card.swift
//  HelloWorld
//
//  Created by Magiczne on 27/11/2020.
//

import ObjectMapper

class Card: Mappable {
    var id: String
    var name: String
    var imageUrl: String
    
    required init?(map: Map) {
        self.id = ""
        self.name = ""
        self.imageUrl = ""
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.imageUrl <- map["imageUrl"]
    }
}
