//
//  ContentView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()  // View model for handling data
    @State private var searchText: String = ""  // Search text entered by the user
    @State private var filteredPokemon: [PokemonResponse] = []  // Caching filtered results

    var body: some View {
        NavigationView {
            ZStack {
                // Darker blue background for the entire content view
                Color(hex: "#2C324C") // Apply dark blue background color here
                    .edgesIgnoringSafeArea(.all) // Ensures the background extends beyond the safe area

                VStack(spacing: 12) {
                    // Search bar
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
                        .onChange(of: searchText) { _ in
                            filterPokemon()  // Call filter function whenever search text changes
                        }

                    // Display loading or error message
                    if viewModel.isLoading {
                        ProgressView("Loading Pokédex...")
                            .foregroundColor(.white)
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        List {
                            ForEach(filteredPokemon) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    // Pass both pokemon and searchText to PokemonRow
                                    PokemonRow(pokemon: pokemon, searchText: $searchText, viewModel: viewModel)
                                }
                                .listRowBackground(Color.clear) // Set clear background for list rows
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Call the fetchPokemon() function to load data when the view appears
                viewModel.fetchPokemon()
            }
        }
    }

    // Function to handle search and filter
    private func filterPokemon() {
        // Perform filtering based on search text
        if searchText.isEmpty {
            filteredPokemon = viewModel.pokemonList
        } else {
            filteredPokemon = viewModel.pokemonList.filter { pokemon in
                pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
