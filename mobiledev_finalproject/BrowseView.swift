//
//  BrowseView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

import SwiftUI

struct BrowseView: View {
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Pokémon name", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Search") {
                        viewModel.search()
                    }
                    .padding(.trailing)
                }

                List(viewModel.results) { pokemon in
                    NavigationLink(destination: DetailView(pokemon: pokemon, viewModel: viewModel)) {
                        HStack {
                            Text(pokemon.name.capitalized)
                            Spacer()
                            if let imageUrl = pokemon.sprites.front_default,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Browse")
        }
    }
}
