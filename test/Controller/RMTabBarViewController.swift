//
//  RMTabBarViewController.swift
//  test
//
//  Created by Vermut xxx on 28.11.2023.
//

import UIKit

protocol FavouritesDelegate: AnyObject {
    func didUpdateFavourites(_ favouriteEpisodes: [RMEpisode])
}

class RMTabBarViewController: UITabBarController {
    var favouriteEpisodes: [RMEpisode] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        print("fav from tab: \(favouriteEpisodes)")
    }
    
    private func setUpTabs() {
        let episodesVC = EpisodesViewController()
        episodesVC.favouritesDelegate = self
        
        let favouritesVC = FavouritesViewController()
        
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: episodesVC)
        let nav3 = UINavigationController(rootViewController: favouritesVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Episodes",
                                       image: UIImage(systemName: "tv"),
                                       tag: 1)
        
        nav3.tabBarItem = UITabBarItem(title: "Favourites",
                                       image: UIImage(systemName: "heart"),
                                       tag: 3)
        
        for nav in [nav1, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav3], animated: true)
    }
    
}

extension RMTabBarViewController: FavouritesDelegate {
    func didUpdateFavourites(_ favouriteEpisodes: [RMEpisode]) {
        self.favouriteEpisodes = favouriteEpisodes
    }
}
