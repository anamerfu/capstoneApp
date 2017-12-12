//
//  Request.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-11-29.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Request: SCNNode {
    
    var randomFoodNumber: Int?
    var randomFoodName: String?
    var numberOfFoodsRequested: Int!
    var currentRequest: String!
    
    var wrapperNode:SCNNode?
    
    var image: UIImage?
    var backgroundShape: SCNPlane?
    var backgroundNode: SCNNode?
    var requestMaterial:SCNMaterial?
    
    var foodwrapperNode:SCNNode?
    var foodNode: SCNNode?
    var foodShape: SCNPlane?

    var xPosition: Float?
    let yPosition: Float?
    let zPosition: Float?
    
    override init() {
        let size = 0.05
        
        self.randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        self.randomFoodName = foods[randomFoodNumber!] + ".png"
        //self.numberOfFoodsRequested = Int(arc4random_uniform(4) + 1)
        self.numberOfFoodsRequested = 2
        self.currentRequest = foods[randomFoodNumber!]
            
        
        self.wrapperNode = SCNNode()
        
        self.image = UIImage(named: randomFoodName!)
        self.backgroundShape = SCNPlane(width: 0.4, height: 0.4)
        self.backgroundNode = SCNNode(geometry: backgroundShape)
        self.backgroundShape?.firstMaterial?.diffuse.contents = UIImage(named: "thoughtBubble.png")
        self.foodwrapperNode = SCNNode()
        
        self.foodShape = SCNPlane(width: 0.07, height: 0.06)
        self.foodNode = SCNNode(geometry:foodShape)
        self.foodShape?.firstMaterial?.diffuse.contents = image
        
        self.xPosition = (foodwrapperNode?.position.x)! - Float(Double(numberOfFoodsRequested) / 2 * size - size / 2)
        self.yPosition = (foodwrapperNode?.position.y)! + 0.055
        self.zPosition = foodwrapperNode?.position.z
        
        self.foodNode?.position = SCNVector3Make(xPosition!, yPosition!, zPosition!)
        
        super.init()
        
    }

    
    func loadObjects() {
        print("loadObjects worked");
        
        let size = 0.05
        backgroundNode?.name = "BackgroundPlane"
        
        backgroundNode?.position = SCNVector3Make((wrapperNode?.position.x)!, (wrapperNode?.position.y)!, (wrapperNode?.position.z)! )
        
        foodwrapperNode?.position = SCNVector3Make((wrapperNode?.position.x)!, (wrapperNode?.position.y)!, (wrapperNode?.position.z)! + 0.001)
        
        wrapperNode?.addChildNode(backgroundNode!)
        wrapperNode?.addChildNode(foodwrapperNode!)

        foodNode?.name = randomFoodName
        foodShape?.firstMaterial?.diffuse.contents = image

        self.addChildNode(wrapperNode!)
        for _ in 1...numberOfFoodsRequested {
            print("adding food ran")
            print("new request: \(foodNode?.name)")
            foodwrapperNode?.addChildNode(foodNode!)
            xPosition? += Float(size)
            print(xPosition)
        }
        
    }

    
    func refreshRandomFoods() {
        
        self.randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        self.randomFoodName = foods[randomFoodNumber!] + ".png"
        //self.numberOfFoodsRequested = Int(arc4random_uniform(4) + 1)
        self.currentRequest = foods[randomFoodNumber!]
        
        print("Foods refreshed. Now requesting \(numberOfFoodsRequested) \(randomFoodName)." )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
