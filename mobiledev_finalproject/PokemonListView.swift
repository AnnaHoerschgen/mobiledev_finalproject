//
//  PokemonListView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct PokemonListView: View {
    let filteredPokemon: [PokemonResponse]

    var body: some View {
        List {
            ForEach(filteredPokemon) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    HStack(spacing: 16) {
                        PokemonImageView(spriteURL: pokemon.sprites.defaultFrontMale)

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
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
}

#Preview {
    PokemonListView(filteredPokemon: [])
}
