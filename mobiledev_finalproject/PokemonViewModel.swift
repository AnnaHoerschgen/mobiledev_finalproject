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
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()

    func fetchPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100") else {
            self.errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonAPIResponse.self, decoder: JSONDecoder())
            .flatMap { response in
                Publishers.MergeMany(response.results.map { self.fetchPokemonDetails(for: $0.name) })
                    .collect()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to load Pokémon: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] detailedPokemons in
                self?.pokemonList = detailedPokemons
            })
            .store(in: &cancellables)
    }

    private func fetchPokemonDetails(for name: String) -> AnyPublisher<PokemonResponse, Error> {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(name)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func toggleFavorite(_ pokemon: PokemonResponse) {
        if let index = favoritePokemons.firstIndex(where: { $0.id == pokemon.id }) {
            favoritePokemons.remove(at: index)
        } else {
            favoritePokemons.append(pokemon)
        }
    }

    var filteredPokemon: [PokemonResponse] {
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct PokemonAPIResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}
