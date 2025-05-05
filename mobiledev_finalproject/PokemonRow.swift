//
//  PokemonRow.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/5/25.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: PokemonResponse
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        HStack {
            // Pokemon Image
            PokemonImageView(spriteURL: pokemon.sprites.defaultFrontMale)

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#FF5C5C")) // Red color for name
                Text("Dex #\(pokemon.nationalDexNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(pokemon.types.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(Color(hex: "#4DA6FF")) // Blue color for types
            }

            Spacer()

            // Favorite Button
            Button(action: {
                viewModel.toggleFavorite(pokemon)
            }) {
                Image(systemName: "star.fill")
                    .foregroundColor(viewModel.favoritePokemons.contains(where: { $0.id == pokemon.id }) ? .yellow : .gray)
            }
            .padding(.trailing)
        }
        .padding(.vertical, 6)
        .background(Color(hex: "#2C324C")) // Darker Blue background for row
        .cornerRadius(10)
    }
}
