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
                if favoritePokemons.isEmpty {
                    Text("No favorites yet")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(favoritePokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRow(pokemon: pokemon, viewModel: PokemonViewModel()) // Pass viewModel to PokemonRow
                        }
                        .listRowBackground(Color.clear) // Clear background for the list row
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
