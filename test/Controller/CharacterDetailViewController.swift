//
//  CharacterDetailViewController.swift
//  test
//
//  Created by Vermut xxx on 29.11.2023.
//

import UIKit

class CharacterDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var character: RMCharacter?
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Informations"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton = UIBarButtonItem(title: "GO BACK", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        let rightButtonImage = UIImage(named: "logoBlack")
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(infoLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            
            infoLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 10),
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let character = character {
            nameLabel.text = character.name
            characterImageView.setImage(from: character.image)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        characterImageView.layer.cornerRadius = characterImageView.frame.size.width / 2
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        // Configure the cell based on the indexPath
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Gender: "
            cell.detailTextLabel?.text = character?.gender ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
        case 1:
            cell.textLabel?.text = "Status: "
            cell.detailTextLabel?.text = character?.status ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
        case 2:
            cell.textLabel?.text = "Species: "
            cell.detailTextLabel?.text = character?.species ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
        case 3:
            cell.textLabel?.text = "Origin: "
            cell.detailTextLabel?.text = character?.origin.name ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
        case 4:
            cell.textLabel?.text = "Type: "
            cell.detailTextLabel?.text = character?.type ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
        case 5:
            cell.textLabel?.text = "Location: "
            cell.detailTextLabel?.text = character?.location.name ?? ""
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.textColor = .systemGray
            
        default:
            break
        }
        
        return cell
    }
}

