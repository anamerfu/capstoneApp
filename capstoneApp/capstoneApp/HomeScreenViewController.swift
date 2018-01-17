//
//  HomeScreenViewController.swift
//  capstoneApp
//
//  Created by Laura Douglas on 2017-10-05.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
import AVFoundation

let playGameController = GameViewController()
let purple = "#7189ff"
var audioPlayer = AVAudioPlayer()

class HomeScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
//        let backgroundSongPath = Bundle.main.path(forResource: "backgroundSong.mp3", ofType:nil)!
//        let backgroundSongURL = URL(fileURLWithPath: backgroundSongPath)
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: backgroundSongURL)
//            audioPlayer.volume = 0.5
//            audioPlayer.numberOfLoops = -1
//            audioPlayer.play()
//            print ("audio played")
//        } catch {
//            // couldn't load file :(
//        }
        MusicHelper.sharedHelper.playBackgroundMusic()
        
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
        
        title.frame = CGRect(x: self.view.frame.size.width / 2 - titleImage!.size.width / 2 , y: 85, width: titleImage!.size.width , height: (titleImage?.size.height)!)
        
        
        self.view.addSubview(background)
        self.view.addSubview(button)
        self.view.addSubview(title)
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        print("Button tapped")
        //audio - set file name & extension
        let pop = Bundle.main.path(forResource: "pop.mp3", ofType:nil)!
        let popURL = URL(fileURLWithPath: pop)
        

        
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.2),
                       initialSpringVelocity: CGFloat(6),
                       options: .allowUserInteraction,
                       animations: {
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: popURL)
                            audioPlayer.play()
                            print ("button audio played")
                        } catch {
                            // couldn't load file :(
                        }
                        sender.transform = .identity

        },
                       completion: { finished in

                        self.navigationController?.pushViewController(playGameController, animated: true)
        });
       
        
    
    }
    

    
    
    
}
