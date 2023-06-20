//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

struct Quote {
    var symbol:String?
    var name:String?
    var currency:String?
    var readableLastChangePercent:String?
    var last:String?
    var variationColor:VariationColor?
    var myMarket:Market?
}

extension Quote {
    enum VariationColor: String, Codable {
        case red
        case green
    }
}

extension Quote: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case currency
        case readableLastChangePercent
        case last
        case variationColor
    }
}
