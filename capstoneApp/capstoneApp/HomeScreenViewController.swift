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
        
        let button = UIButton(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 125, width: 150, height: 60))
        
        let titleImage = UIImage(named: "thumper.png")
        let title = UIImageView(image: titleImage!)
        
        let bgImage = UIImage(named: "backgroundFoods.png")
        let background = UIImageView(image: bgImage!)
        
        
        //background.image = UIImage(named: "backgroundFoods.png")
        background.frame = CGRect(x:-20, y:-30, width: (bgImage?.size.width)! * 0.9 , height: (bgImage?.size.height)! * 0.9)
        button.backgroundColor = UIColor(hex: "00dfdc")
        button.layer.cornerRadius = 30
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 32)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        title.frame = CGRect(x: self.view.frame.size.width / 2 - titleImage!.size.width / 2 , y: 70, width: titleImage!.size.width , height: (titleImage?.size.height)!)
        
        
        self.view.addSubview(background)
        self.view.addSubview(button)
        self.view.addSubview(title)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        self.navigationController?.pushViewController(playGameController, animated: true)
    }
    
    
    
}
