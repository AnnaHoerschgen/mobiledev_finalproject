//
//  PokemonImageView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct PokemonImageView: View {
    let spriteURL: String?

    var body: some View {
        Group {
            if let spriteURL = spriteURL, let url = URL(string: spriteURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 50, height: 50)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    PokemonImageView(spriteURL: nil)
}
