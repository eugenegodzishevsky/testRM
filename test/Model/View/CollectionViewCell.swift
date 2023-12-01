//
//  CollectionViewCell.swift
//  test
//
//  Created by Vermut xxx on 28.11.2023.
//

import UIKit

protocol EpisodeCellDelegate: AnyObject {
    func didTapHeartButton(episode: RMEpisode)
}

class CollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "EpisodeCell"
    
    weak var delegate: EpisodeCellDelegate?
    var episode: RMEpisode?
    
    var onTap: (() -> Void)?
    
    var isFavourite = false
    
    
    var imageView: UIImageView!
    var seriesNameLabel: UILabel!
    var nameLabel: UILabel!
    var playButtonImageView: UIImageView!
    var seriesCodeLabel: UILabel!
    var heartImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.addSubview(imageView)
        
        seriesNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20))
        seriesNameLabel.textAlignment = .left
        seriesNameLabel.backgroundColor = .white
        seriesNameLabel.translatesAutoresizingMaskIntoConstraints = false
        seriesNameLabel.contentMode = .scaleAspectFit
        
        contentView.addSubview(seriesNameLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20))
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.textAlignment = .left
        nameLabel.backgroundColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.contentMode = .scaleAspectFit
        contentView.addSubview(nameLabel)
        
        playButtonImageView = UIImageView(image: UIImage(systemName: "tv"))
        playButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        playButtonImageView.contentMode = .scaleAspectFit
        contentView.addSubview(playButtonImageView)
        
        seriesCodeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20))
        seriesCodeLabel.textAlignment = .left
        seriesCodeLabel.backgroundColor = .white
        seriesCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        seriesCodeLabel.contentMode = .scaleAspectFit
        contentView.addSubview(seriesCodeLabel)
        
        heartImageView = UIImageView(image: UIImage(systemName: "heart"))
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.contentMode = .scaleAspectFill
        heartImageView.isUserInteractionEnabled = true
        contentView.addSubview(heartImageView)
        
        addConstraints()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(heartImageViewTapped))
        heartImageView.isUserInteractionEnabled = true
        heartImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTap() {
        onTap?()
    }
    
    @objc func heartImageViewTapped() {
        if let episode = episode {
            delegate?.didTapHeartButton(episode: episode)
        }
        isFavourite = !isFavourite
        heartImageView.tintColor = isFavourite ? UIColor.red : UIColor.systemBlue
        
        heartImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            self.heartImageView.transform = CGAffineTransform.identity
        },
                       completion: nil)
        
        if isFavourite {
            print("add")
            
        } else {
            print("delete")
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            playButtonImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            playButtonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            seriesNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            seriesNameLabel.leadingAnchor.constraint(equalTo: playButtonImageView.trailingAnchor),
            
            seriesCodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            seriesCodeLabel.leadingAnchor.constraint(equalTo: seriesNameLabel.trailingAnchor),
            
            heartImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
}

extension UIImageView {
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            // If the URL string is not a valid URL, set the image to a default one or leave it blank
            self.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from task.")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

