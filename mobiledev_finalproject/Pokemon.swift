//
//  Pokemon.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

struct Pokemon: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let sprites: Sprites

    struct Sprites: Codable, Equatable {
        let front_default: String?
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}
