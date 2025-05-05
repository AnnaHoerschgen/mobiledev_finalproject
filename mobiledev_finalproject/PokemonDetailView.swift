//
//  PokemonDetailView.swift
//  FinalProject
//
//  Created by HOERSCHGEN, ANNA M. on 4/28/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonResponse

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1B1F3B"), // Dark Blue
                    Color(hex: "#2C324C")  // Darker Blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 16) {
                    Text(pokemon.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#FF5C5C")) // Red color for name

                    Text("National Dex #: \(pokemon.nationalDexNumber)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Use PokemonImageView here for sprite display
                    PokemonImageView(spriteURL: pokemon.sprites.defaultFrontMale)

                    HStack {
                        ForEach(pokemon.types, id: \.self) { type in
                            Text(type)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "#4DA6FF").opacity(0.2)) // Blue color for type background
                                .foregroundColor(Color(hex: "#4DA6FF")) // Blue color for type text
                                .cornerRadius(12)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Abilities")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#FF5C5C")) // Red color for Abilities header

                        ForEach(pokemon.abilities, id: \.name) { ability in
                            VStack(alignment: .leading) {
                                Text(ability.name)
                                    .foregroundColor(Color(hex: "#4DA6FF")) // Blue color for ability name
                                    .fontWeight(.semibold)
                                Text(ability.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        if !pokemon.hiddenAbilities.isEmpty {
                            Text("Hidden Abilities")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#FF5C5C")) // Red color for Hidden Abilities header
                                .padding(.top, 8)

                            ForEach(pokemon.hiddenAbilities, id: \.name) { ability in
                                VStack(alignment: .leading) {
                                    Text(ability.name)
                                        .foregroundColor(Color(hex: "#4DA6FF")) // Blue color for hidden ability name
                                        .fontWeight(.semibold)
                                    Text(ability.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }

                    if !pokemon.evolutionLine.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Evolution Line")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#FF5C5C")) // Red color for Evolution Line header

                            ForEach(pokemon.evolutionLine) { stage in
                                HStack {
                                    Text(stage.name)
                                        .foregroundColor(stage.isCurrent ? Color(hex: "#FF5C5C") : .white) // Red for current stage
                                        .fontWeight(stage.isCurrent ? .bold : .regular)
                                    if let details = stage.evolutionDetails {
                                        Text("(\(details))")
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
