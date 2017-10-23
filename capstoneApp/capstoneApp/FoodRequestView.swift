//
//  FoodRequestView.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-23.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit

class FoodRequestView: UIView {
    
    var shouldSetupConstraints = true
    
    let foodImageView = UIImageView()

    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        foodImageView.image = UIImage(named: "apple.png")
        foodImageView.frame = CGRect(x: 5, y: 5, width: 25, height: 25)
        self.addSubview(foodImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

