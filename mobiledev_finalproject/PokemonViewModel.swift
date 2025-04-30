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
    @Published var hasSearched: Bool = false  // Track search attempts

    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"

    // Fetch all Pokémon or a specific Pokémon if a search term is provided
    func fetchPokemon(searchTerm: String? = nil) {
        var urlString: String
        
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            urlString = "\(baseURL)\(searchTerm.lowercased())"
        } else {
            urlString = baseURL
        }

        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil
        hasSearched = searchTerm != nil && !searchTerm!.isEmpty // Set flag only when a search term is provided

        // Perform the network request
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load Pokémon: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemon in
                self?.pokemonList = [pokemon]  // Store only the fetched Pokémon (as we're now fetching a single Pokémon)
            })
            .store(in: &cancellables)
    }

    // Fetch the list of all Pokémon (pagination can be handled if necessary)
    func fetchAllPokemon() {
        let urlString = "\(baseURL)"  // Fetch the first 100 Pokémon, adjust as needed
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil
        hasSearched = false // No search was made

        // Fetch the list of all Pokémon
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load Pokémon list: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.pokemonList = response.results // Store the list of Pokémon
            })
            .store(in: &cancellables)
    }

    // Optional: Filter Pokémon by region or type (can expand based on actual API structure)
    func filterByRegion(_ region: String) -> [PokemonResponse] {
        return pokemonList.filter { $0.region.lowercased() == region.lowercased() }
    }

    func getPokemon(by id: Int) -> PokemonResponse? {
        return pokemonList.first { $0.id == id }
    }
}
