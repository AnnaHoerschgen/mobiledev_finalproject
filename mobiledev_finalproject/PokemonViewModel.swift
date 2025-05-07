//
//  PokemonViewModel.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

import SwiftUI

import Foundation

class PokemonViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Pokemon] = []
    @Published var favorites: [Pokemon] = []

    private let api = APIService()

    func search() {
        guard !searchText.isEmpty else { return }
        api.fetchPokemon(named: searchText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemon):
                    self.results = [pokemon]
                case .failure:
                    self.results = []
                }
            }
        }
    }

    func toggleFavorite(_ pokemon: Pokemon) {
        if let index = favorites.firstIndex(of: pokemon) {
            favorites.remove(at: index)
        } else {
            favorites.append(pokemon)
        }
    }

    func isFavorite(_ pokemon: Pokemon) -> Bool {
        favorites.contains(pokemon)
    }
}
