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
                            filterPokemon()  // Fetch Pokémon based on the updated search text
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
                        pokemonListView  // Displays the filtered Pokémon list view
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Call the fetchPokemon() function when the view appears
                viewModel.fetchPokemon(searchText: searchText)
            }
        }
    }

    
    // View for displaying the list of Pokémon
    private var pokemonListView: some View {
        List {
            ForEach(filteredPokemon) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    // Pass pokemon, the searchText value as searchTerm, and the viewModel
                    PokemonRow(pokemon: pokemon, searchTerm: searchText, viewModel: viewModel)
                }
                .listRowBackground(Color.clear) // Set clear background for list rows
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    // Function to handle filtering Pokémon list based on search text
    private func filterPokemon() {
        viewModel.fetchPokemon(searchText: searchText)
    }
    
    // Computed property to filter the Pokémon list based on the search text
    private var filteredPokemon: [PokemonResponse] {
        if searchText.isEmpty {
            return viewModel.pokemonList
        } else {
            return viewModel.pokemonList.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
