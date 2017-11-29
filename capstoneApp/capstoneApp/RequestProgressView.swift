//
//  RequestProgressView.swift
//  capstoneApp
//
//  Created by Laura Douglas on 2017-11-27.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit

class RequestProgressView: UIView {
    
    let foodRequest = FoodRequestView()
    var numberRequested: String!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    override init(frame: CGRect){
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let numberRequested: String? = String(foodRequest.numberOfFoodsRequested)
        let basket = UIImage(named: "basket")
        let basketImageView = UIImageView(image: basket!)
       
        basketImageView.frame = CGRect(x: screenWidth - 100, y: screenHeight - 100, width: 86, height: 97)
        label.center = CGPoint(x: screenWidth - 57, y: screenHeight - 30)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Nunito-Bold", size: 20)
//        label.text = numberRequested
        super.init(frame: frame)
        self.addSubview(basketImageView)
        self.addSubview(label)
        
    }
    
    func refreshProgress() {
        let numberRequested: String? = String(foodRequest.numberOfFoodsRequested)
        label.text = numberRequested
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
