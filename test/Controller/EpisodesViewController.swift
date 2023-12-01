//
//  EpisodesViewController.swift
//  test
//
//  Created by Vermut xxx on 28.11.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var networkManager = NetworkManager()
    var episodes: [RMEpisode] = []
    var favouriteEpisodes: [RMEpisode] = []
    var filteredEpisodes: [RMEpisode] = []
    
    weak var favouritesDelegate: FavouritesDelegate?
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Name or episode(ex. S01E01)"
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton = UIBarButtonItem(title: "GO BACK", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.size.width/2.2,
                                 height: view.frame.size.width/2.2)
        
        layout.itemSize = CGSize(width: 300, height: 400)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        networkManager.obtainEpisodes { (episodes) in
            DispatchQueue.main.async {
                self.episodes = episodes
                self.filteredEpisodes = episodes
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! CollectionViewCell
        
        let episode = filteredEpisodes[indexPath.row]
        cell.seriesNameLabel.text = episode.name
        cell.seriesCodeLabel.text = episode.episode
        cell.delegate = self
        cell.episode = episode
        
        
        // Assuming you have a method to set the image from a URL
        cell.imageView.setImage(from: episode.url)
        
        // If the characters array is not empty, get a random character's image
        if !episode.characters.isEmpty {
            let randomCharacterURL = episode.characters.randomElement()!
            
            networkManager.obtainCharacterImage(from: randomCharacterURL) { (imageURL) in
                DispatchQueue.main.async {
                    cell.imageView.setImage(from: imageURL)
                }
            }
            
            networkManager.obtainCharacterName(from: randomCharacterURL) { (name) in
                DispatchQueue.main.async {
                    cell.nameLabel.text = name
                }
            }
            
            cell.onTap = { [weak self] in
                let characterURL = randomCharacterURL
                
                self?.networkManager.obtainCharacter(from: characterURL) { (character) in
                    DispatchQueue.main.async {
                        let characterDetailViewController = CharacterDetailViewController()
                        characterDetailViewController.character = character
                        self?.navigationController?.pushViewController(characterDetailViewController, animated: true)
                    }
                }
            }
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredEpisodes = episodes
        } else {
            filteredEpisodes = episodes.filter { $0.episode.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}

extension EpisodesViewController: EpisodeCellDelegate {
    func didTapHeartButton(episode: RMEpisode) {
        if let index = FavouritesManager.shared.favouriteEpisodes.firstIndex(where: { $0.id == episode.id }) {
            FavouritesManager.shared.favouriteEpisodes.remove(at: index)
            print("Удален эпизод: \(episode.name)")
            print("fav from epi: \(FavouritesManager.shared.favouriteEpisodes)")
            
        } else {
            FavouritesManager.shared.favouriteEpisodes.append(episode)
            print("Добавлен эпизод: \(episode.name)")
            print("fav from Epi: \(FavouritesManager.shared.favouriteEpisodes)")
        }
        favouritesDelegate?.didUpdateFavourites(FavouritesManager.shared.favouriteEpisodes)
    }
}
