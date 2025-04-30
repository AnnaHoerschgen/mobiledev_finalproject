//
//  PokemonListView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct PokemonListView: View {
    let filteredPokemon: [PokemonResponse]
    @ObservedObject var viewModel: PokemonViewModel // Add this line to pass the viewModel

    var body: some View {
        List {
            ForEach(filteredPokemon) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon, viewModel: viewModel)) {
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
    // Pass the viewModel from ContentView or a mock instance here
    PokemonListView(filteredPokemon: [], viewModel: PokemonViewModel())
}
