//
//  DetailView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

import SwiftUI

struct DetailView: View {
    let pokemon: Pokemon
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let imageUrl = pokemon.sprites.front_default,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
            }

            Text(pokemon.name.capitalized)
                .font(.largeTitle)

            Button(action: {
                viewModel.toggleFavorite(pokemon)
            }) {
                Label(viewModel.isFavorite(pokemon) ? "Unfavorite" : "Favorite", systemImage: viewModel.isFavorite(pokemon) ? "heart.fill" : "heart")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
