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
        
        label.center = CGPoint(x: screenWidth - 70, y: screenHeight - 70)
        label.textAlignment = .center
        label.textColor = .white
//        label.text = numberRequested
        super.init(frame: frame)
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
