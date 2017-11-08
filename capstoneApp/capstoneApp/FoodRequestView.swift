//
//  FoodRequestView.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-23.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit

var currentRequestNumber = 0

class FoodRequestView: UIView {
    
    var shouldSetupConstraints = true
    
    
    //let foodImageView = UIImageView()
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        
        let randomFoodName = foods[randomFoodNumber] + ".png"
        let foodImage = UIImage(named: randomFoodName)
        let numberOfFoods = arc4random_uniform(4) + 1
        
        currentRequest = foods[randomFoodNumber]
        
        print(randomFoodNumber)
        print(randomFoodName)
        print (numberOfFoods)
        
        currentRequestNumber = Int(numberOfFoods)
        
        for index in 1...currentRequestNumber{
 
            let foodImageView: UIImageView = UIImageView(image: foodImage)
            foodImageView.frame = CGRect(x: Int(5 + (index * 25)), y: 5, width: 25, height: 25)
            self.addSubview(foodImageView)
            
        }
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

