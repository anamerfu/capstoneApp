//
//  InstructionsView.swift
//  capstoneApp
//
//  Created by Laura Douglas on 2018-01-15.
//  Copyright © 2018 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit

class InstructionsView: UIView {
    var label: UILabel!
    
    override init(frame: CGRect){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let frame = CGRect(x: (screenWidth - 350) / 2, y: screenHeight + 100, width: 350, height: 80)
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor(red:0.24, green:0.37, blue:1.00, alpha:0.8)
        self.layer.cornerRadius = 40.0
        label = UILabel(frame: CGRect(x: 50, y: 50, width: 280, height: 200))
        label.center = CGPoint(x: 165, y: 40)
        label.text = "Look around the room for the patch of grass!"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Nunito-Bold", size: 18)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
