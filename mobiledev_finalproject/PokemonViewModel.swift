//
//  PokemonViewModel.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 4/28/25.
//

import Foundation
import SwiftUI
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    
    // Sample fetch method (replace with your actual URL)
    func fetchPokemon() {
        guard let url = URL(string: "https://example.com/api/pokemon") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PokemonResponse].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load Pokémon: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemons in
                self?.pokemonList = pokemons
            })
            .store(in: &cancellables)
    }

    // Optional: Filter by region or type, etc.
    func filterByRegion(_ region: String) -> [PokemonResponse] {
        return pokemonList.filter { $0.region.lowercased() == region.lowercased() }
    }

    func getPokemon(by id: Int) -> PokemonResponse? {
        return pokemonList.first { $0.id == id }
    }
}
