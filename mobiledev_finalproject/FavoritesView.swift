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
        List(favoritePokemons) { pokemon in
            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                HStack {
                    if let spriteURL = pokemon.sprites.defaultFrontMale,
                       let url = URL(string: spriteURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable().scaledToFit().frame(width: 50, height: 50)
                            case .failure:
                                Image(systemName: "photo").foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    Text(pokemon.name)
                        .foregroundColor(.white)
                }
            }
        }
        .background(Color(hex: "#1B1F3B"))
        .listStyle(PlainListStyle())
    }
}
