//
//  PokemonModel.swift
//  UserProfile
//
//  Created by danielmateos14 on 05/08/23.
//

import Foundation

struct PokemonModel: Codable {
    let name: String
    let sprites: Sprites?
    let forms: [Forms]?
    let species: Species?
}

struct Sprites: Codable {
    let backDefault: String
    let backFemale: String?
    let backShiny: String
    let backShinyFemale: String?
    let frontDefault: String
    let frontFemale: String?
    let frontShiny: String
    let frontShinyFemale: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }

    // CodingKeys personalizados para omitir las propiedades nulas
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(backDefault, forKey: .backDefault)
        try container.encodeIfPresent(backFemale, forKey: .backFemale)
        try container.encode(backShiny, forKey: .backShiny)
        try container.encodeIfPresent(backShinyFemale, forKey: .backShinyFemale)
        try container.encode(frontDefault, forKey: .frontDefault)
        try container.encodeIfPresent(frontFemale, forKey: .frontFemale)
        try container.encode(frontShiny, forKey: .frontShiny)
        try container.encodeIfPresent(frontShinyFemale, forKey: .frontShinyFemale)
    }
}

struct Forms: Codable {
    let name: String
    let url: String
}

struct Species: Codable {
    let name: String
    let url: String
}


