//
//  ApiResponse.swift
//  HelloWorld
//
//  Created by Magiczne on 27/11/2020.
//

import ObjectMapper

class CardsResponse: Mappable {
    var cards: [Card]
    
    required init?(map: Map) {
        self.cards = []
    }
    
    func mapping(map: Map) {
        self.cards <- map["cards"]
    }
}
