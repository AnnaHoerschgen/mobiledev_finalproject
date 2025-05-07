//
//  ContentView.swift
//  mobiledev_finalproject
//
//  Created by HOERSCHGEN, ANNA M. on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokemonViewModel()

    var body: some View {
        TabView {
            BrowseView(viewModel: viewModel)
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }

            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
