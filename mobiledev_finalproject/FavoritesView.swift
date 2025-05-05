//
//  FavoritesView.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 5/5/25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PokemonViewModel  // Use viewModel here

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
                if viewModel.favoritePokemons.isEmpty {
                    Text("No favorites yet")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.favoritePokemons) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonRow(pokemon: pokemon, searchTerm: "", viewModel: viewModel)
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
