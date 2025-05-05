//
//  PokemonViewModel.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 4/28/25.
//

import Foundation
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonResponse] = []
    @Published var favoritePokemons: [PokemonResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Add searchText property to the view model
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    func fetchPokemon(searchText: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load Pokémon: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.pokemonList = apiResponse.results
            })
            .store(in: &cancellables)
    }

    func toggleFavorite(_ pokemon: PokemonResponse) {
        if let index = favoritePokemons.firstIndex(where: { $0.id == pokemon.id }) {
            favoritePokemons.remove(at: index)
        } else {
            favoritePokemons.append(pokemon)
        }
    }

    // Modify filteredPokemon to use the view model's searchText
    var filteredPokemon: [PokemonResponse] {
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct PokemonAPIResponse: Codable {
    let results: [PokemonResponse]
}
