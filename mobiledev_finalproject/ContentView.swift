//
//  ContentView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#1B1F3B"),
                        Color(hex: "#2C324C")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    TextField("Search Pokémon...", text: $searchText)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )

                    if viewModel.isLoading {
                        ProgressView("Loading Pokédex...")
                            .foregroundColor(.white)
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        List {
                            ForEach(filteredPokemon) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
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
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchPokemon()
            }
        }
    }

    private var filteredPokemon: [PokemonResponse] {
        if searchText.isEmpty {
            return viewModel.pokemonList
        } else {
            return viewModel.pokemonList.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    ContentView()
}
