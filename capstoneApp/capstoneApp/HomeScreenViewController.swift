//
//  HomeScreenViewController.swift
//  capstoneApp
//
//  Created by Laura Douglas on 2017-10-05.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
let playGameController = GameViewController()
let purple = "#7189ff"

class HomeScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let button = UIButton(frame: CGRect(x: (self.view.frame.size.width - 100) / 2, y: self.view.frame.size.height - 150, width: 100, height: 50))
        let label = UILabel(frame: CGRect(x: (self.view.frame.size.width - 400) / 2, y: (self.view.frame.size.height - 600) / 2, width: 400, height: 500))
        
        button.backgroundColor = UIColor(hex: "00dfdc")
        button.layer.cornerRadius = 10
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
//        label.center = CGPoint(x: self.view.frame.size.width - 325, y: self.view.frame.size.height - 250)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Nunito-Bold", size: 20)
        label.text = "Look for the patch of grass and tap to find the bunny! Help him find the food he wants to eat by looking around the room and tapping on the correct food!"
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        self.navigationController?.pushViewController(playGameController, animated: true)
    }
    
    
    
}
