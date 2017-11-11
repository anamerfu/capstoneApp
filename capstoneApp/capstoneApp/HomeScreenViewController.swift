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
        
        print("hello i am home screen")
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = UIColor(hex: "00dfdc")
        button.layer.cornerRadius = 10
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        self.navigationController?.pushViewController(playGameController, animated: true)
    }
    
    
    
}
