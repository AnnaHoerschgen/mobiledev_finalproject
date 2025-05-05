//
//  FavoritesView.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 5/5/25.
//

import SwiftUI

struct FavoritesView: View {
    let favoritePokemons: [PokemonResponse]

    var body: some View {
        ZStack {
            // Background gradient for Favorites screen
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1B1F3B"), // Dark Blue
                    Color(hex: "#2C324C")  // Darker Blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                // Show message if there are no favorites
                if favoritePokemons.isEmpty {
                    Text("No favorites yet")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(favoritePokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            // Pass pokemon and viewModel to PokemonRow
                            PokemonRow(pokemon: pokemon, searchTerm: "", viewModel: PokemonViewModel())
                        }
                        .listRowBackground(Color.clear) // Set clear background for list rows
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .padding(.top)
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
