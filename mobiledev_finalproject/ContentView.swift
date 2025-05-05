//
//  ContentView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()  // View model for handling data

    var body: some View {
        NavigationView {
            ZStack {
                // Darker blue background for the entire content view
                Color(hex: "#2C324C") // Apply dark blue background color here
                    .edgesIgnoringSafeArea(.all) // Ensures the background extends beyond the safe area
                
                VStack(spacing: 12) {
                    // Search bar
                    TextField("Search Pokémon...", text: $viewModel.searchText)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )

                    // Display loading or error message
                    if viewModel.isLoading {
                        ProgressView("Loading Pokédex...")
                            .foregroundColor(.white)
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Show search results only if the user has searched or no search
                        pokemonListView
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchPokemon()  // Fetch Pokémon when the view appears
            }
        }
    }

    // View for displaying the list of Pokémon
    private var pokemonListView: some View {
        List {
            ForEach(viewModel.filteredPokemon) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    PokemonRow(pokemon: pokemon, searchTerm: viewModel.searchText, viewModel: viewModel)
                }
                .listRowBackground(Color.clear) // Set clear background for list rows
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
}

#Preview {
    ContentView()
}
