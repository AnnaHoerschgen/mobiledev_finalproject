//
//  FavoritesView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 5/7/25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        NavigationView {
            List(viewModel.favorites) { pokemon in
                NavigationLink(destination: DetailView(pokemon: pokemon, viewModel: viewModel)) {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
