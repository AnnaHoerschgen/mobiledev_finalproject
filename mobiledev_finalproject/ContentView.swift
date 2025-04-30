//
//  ContentView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#1B1F3B"),
                        Color(hex: "#2C324C")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    // Search Text Field
                    TextField("Search Pokémon...", text: $searchText)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .onSubmit {
                            handleSearchTextChange() // Trigger search on submit
                        }

                    // Show loading indicator only when searching
                    if viewModel.isLoading && !searchText.isEmpty {
                        ProgressView("Loading Pokédex...")
                            .foregroundColor(.white)
                            .padding()
                    } else if let error = viewModel.errorMessage, viewModel.hasSearched {
                        // Only show error message after a failed search attempt
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        // Display Pokemon List
                        PokemonListView(filteredPokemon: getFilteredPokemon(), viewModel: viewModel) // Pass viewModel
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Initial fetch if searchText is empty
                if searchText.isEmpty {
                    viewModel.fetchPokemon()
                }
            }
        }
    }

    // Handle the logic when the search text changes (triggered manually)
    private func handleSearchTextChange() {
        if !searchText.isEmpty {
            viewModel.isLoading = true
            viewModel.fetchPokemon(searchTerm: searchText)
        } else {
            viewModel.isLoading = false
        }
    }

    // Get filtered Pokémon based on search text
    private func getFilteredPokemon() -> [PokemonResponse] {
        if searchText.isEmpty {
            return viewModel.pokemonList
        } else {
            return filterPokemon(searchTerm: searchText)
        }
    }

    // Filter Pokémon list based on the search term
    private func filterPokemon(searchTerm: String) -> [PokemonResponse] {
        return viewModel.pokemonList.filter { pokemon in
            pokemon.name.lowercased().contains(searchTerm.lowercased())
        }
    }
}

#Preview {
    ContentView()
}
