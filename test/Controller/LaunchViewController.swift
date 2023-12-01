//
//  LaunchViewController.swift
//  test
//
//  Created by Vermut xxx on 30.11.2023.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let imageLogo = UIImageView(image: UIImage(named: "logo"))
    let imagePortal = UIImageView(image: UIImage(named: "portal"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewWidth: CGFloat = 300
        let imageViewHeight: CGFloat = 100
        
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        imagePortal.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageLogo)
        view.addSubview(imagePortal)
        
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -imageLogo.frame.height / 2 - 10),
            imageLogo.widthAnchor.constraint(equalToConstant: imageViewWidth),
            imageLogo.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            imagePortal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePortal.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 20)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = Float.infinity
        
        imagePortal.layer.add(rotationAnimation, forKey: nil)
    }
}
