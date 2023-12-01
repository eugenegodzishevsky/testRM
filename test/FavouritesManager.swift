//
//  FavouritesManager.swift
//  test
//
//  Created by Vermut xxx on 01.12.2023.
//

import Foundation

class FavouritesManager {
    static let shared = FavouritesManager()

    var favouriteEpisodes: [RMEpisode] = []

    private init() {}
}
