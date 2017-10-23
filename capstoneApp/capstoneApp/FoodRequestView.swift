//
//  FoodRequestView.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-23.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit

let foods: Array = ["apple.png", "cake.png", "grapes.png", "icecream.png", "orange.png", "pumpkin.png"];

class FoodRequestView: UIView {
    
    var shouldSetupConstraints = true
    
    //let foodImageView = UIImageView()

    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let randomFoodNumber = Int (arc4random_uniform (UInt32 (foods.count + 1) ) )
        let randomFoodName = foods[randomFoodNumber]
        let foodImage = UIImage(named: randomFoodName)
        let numberOfFoods = arc4random_uniform(6)
        
        
        for index in 1...numberOfFoods {
            
            let foodImageView: UIImageView = UIImageView(image: foodImage)
            foodImageView.frame = CGRect(x: Int(5 + (index * 25)), y: 5, width: 25, height: 25)
            self.addSubview(foodImageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

