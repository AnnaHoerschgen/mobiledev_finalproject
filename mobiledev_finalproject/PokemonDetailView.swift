//
//  PokemonDetailView.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 4/28/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonResponse
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#FF5C5C"))
                
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
                                .frame(width: 200, height: 200)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                Text("Dex #\(pokemon.nationalDexNumber)")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Types: \(pokemon.types.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#4DA6FF"))
                
                if !viewModel.abilities.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Abilities")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C"))
                        ForEach(viewModel.abilities, id: \.name) { ability in
                            Text(ability.name.capitalized)
                                .font(.subheadline)
                        }
                    }
                }

                if !viewModel.forms.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Forms")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C"))
                        ForEach(viewModel.forms, id: \.formName) { form in
                            Text(form.formName.capitalized)
                                .font(.subheadline)
                        }
                    }
                }

                if !viewModel.gameAppearances.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Game Appearances")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C"))
                        ForEach(viewModel.gameAppearances, id: \.name) { game in
                            Text(game.name.capitalized)
                                .font(.subheadline)
                        }
                    }
                }

                if !viewModel.moves.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Moves")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C"))
                        ForEach(viewModel.moves, id: \.name) { move in
                            Text(move.name.capitalized)
                                .font(.subheadline)
                        }
                    }
                }

                if !viewModel.stats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stats")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C"))
                        ForEach(viewModel.stats, id: \.name) { stat in
                            Text("\(stat.name.capitalized): \(stat.baseStat)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchAbilities(for: pokemon)
            viewModel.fetchForms(for: pokemon)
            viewModel.fetchGameAppearances(for: pokemon)
            viewModel.fetchMoveDetails(for: pokemon)
            viewModel.fetchStatDetails(for: pokemon)
        }
        .navigationBarTitle(pokemon.name.capitalized, displayMode: .inline)
    }
}
