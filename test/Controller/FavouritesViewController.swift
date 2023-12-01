//
//  FavouritesViewController.swift
//  test
//
//  Created by Vermut xxx on 29.11.2023.
//

import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton = UIBarButtonItem(title: "GO BACK", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        //UICollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.size.width/2.2,
                                 height: view.frame.size.width/2.2)
        
        layout.itemSize = CGSize(width: 300, height: 400)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: "FavouriteEpisodeCell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        print("fav from FAV: \(FavouritesManager.shared.favouriteEpisodes.count)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavouritesManager.shared.favouriteEpisodes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteEpisodeCell", for: indexPath) as! FavouritesCollectionViewCell
        
        let episode = FavouritesManager.shared.favouriteEpisodes[indexPath.row]
        cell.seriesNameLabel.text = episode.name
        cell.seriesCodeLabel.text = episode.episode
        cell.episode = episode
        cell.imageView.setImage(from: episode.url)
        
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
}
extension FavouritesViewController: FavouritesCollectionViewCellDelegate {
    func didChangeFavouriteStatus(for cell: FavouritesCollectionViewCell) {
        collectionView.reloadData()
        print("fav from FAV: \(FavouritesManager.shared.favouriteEpisodes.count)")
        
    }
}

