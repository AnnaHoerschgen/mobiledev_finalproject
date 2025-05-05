//
//  PokemonResponse.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 4/28/25.
//

import Foundation

struct PokemonResponse: Identifiable, Codable {
    let id: Int
    let name: String
    let nationalDexNumber: Int
    let types: [String]
    let category: String
    let evolutionLine: [EvolutionStage]
    let region: String
    let abilities: [Ability]
    let hiddenAbilities: [Ability]
    let movePool: MovePool
    let games: [String]
    let sprites: SpriteData
    let alternateForms: [PokemonResponse]?
}

// MARK: Supporting Models

struct EvolutionStage: Codable, Identifiable {
    var id: Int { pokemonID }
    let pokemonID: Int
    let name: String
    let evolutionDetails: String?
    let isCurrent: Bool
}

struct Ability: Codable {
    let name: String
    let description: String
}

struct MovePool: Codable {
    let levelUpMoves: [Move]
    let tmHmMoves: [Move]
    let eggMoves: [Move]
}

struct Move: Codable {
    let name: String
    let levelLearnedAt: Int?
}

struct SpriteData: Codable {
    let defaultFrontMale: String?
    let defaultFrontFemale: String?
    let shinyFrontMale: String?
    let shinyFrontFemale: String?
    let otherForms: [SpriteVariant]
}

struct SpriteVariant: Codable {
    let formName: String
    let spriteURL: String
}
