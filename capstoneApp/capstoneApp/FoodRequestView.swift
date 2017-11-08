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
    
    var randomFoodNumber: Int!
    var randomFoodName: String!
    var foodImage: UIImage!
    var numberOfFoodsRequested: Int!
    var currentRequest: String!
    //var currentRequestNumber: Int!

    //let foodImageView = UIImageView()
    
      override init(frame: CGRect){
        
        self.randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        self.randomFoodName = foods[randomFoodNumber] + ".png"
        self.foodImage = UIImage(named: randomFoodName)
        self.numberOfFoodsRequested = Int(arc4random_uniform(4) + 1)
        self.currentRequest = foods[randomFoodNumber]
        super.init(frame: frame)
        

        
        print("requested \(numberOfFoodsRequested) \(foods[randomFoodNumber])")

        
        //currentRequestNumber = Int(numberOfFoods)
        
        for index in 1...numberOfFoodsRequested{
 
            let foodImageView: UIImageView = UIImageView(image: foodImage)
            foodImageView.frame = CGRect(x: Int(5 + (index * 25)), y: 5, width: 25, height: 25)
            self.addSubview(foodImageView)
            
        }
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

