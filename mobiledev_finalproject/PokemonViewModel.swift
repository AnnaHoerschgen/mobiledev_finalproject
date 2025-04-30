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
    
    // Fetch Pokémon from API, either all or based on search term
    func fetchPokemon(searchTerm: String? = nil) {
        let baseUrl = "https://example.com/api/pokemon" // Replace with your actual API URL
        var urlString = baseUrl
        
        // If a search term is provided, append it to the URL (assuming the API supports search)
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            urlString += "?search=\(searchTerm)"
        }
        
        guard let url = URL(string: urlString) else {
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

    // Optional: Filter Pokémon by region (if region info is available)
    func filterByRegion(_ region: String) -> [PokemonResponse] {
        return pokemonList.filter { $0.region.lowercased() == region.lowercased() }
    }

    // Fetch specific Pokémon by ID
    func getPokemon(by id: Int) -> PokemonResponse? {
        return pokemonList.first { $0.id == id }
    }
}
