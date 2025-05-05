//
//  PokemonRow.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/5/25.
//

import SwiftUI

struct PokemonRow: View {
    let pokemon: PokemonResponse
    let searchTerm: String
    let viewModel: PokemonViewModel

    var body: some View {
        HStack(spacing: 16) {
            if let spriteURL = pokemon.sprites.defaultFrontMale,
               let url = URL(string: spriteURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#FF5C5C"))
                Text("Dex #\(pokemon.nationalDexNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(pokemon.types.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundColor(Color(hex: "#4DA6FF"))
            }
        }
        .padding(.vertical, 6)
        .background(Color.clear)
    }
}
