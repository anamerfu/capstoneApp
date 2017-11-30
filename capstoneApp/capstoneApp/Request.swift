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
    
    override init() {
        
        self.randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        self.randomFoodName = foods[randomFoodNumber!] + ".png"
        self.numberOfFoodsRequested = Int(arc4random_uniform(4) + 1)
        self.currentRequest = foods[randomFoodNumber!]
            
        
        self.wrapperNode = SCNNode()
        
        self.image = UIImage(named: randomFoodName!)
        self.backgroundShape = SCNPlane(width: 0.2, height: 0.1)
        self.backgroundNode = SCNNode(geometry: backgroundShape)
        //self.planeShape?.firstMaterial?.diffuse.contents = image
        
        self.foodwrapperNode = SCNNode()
        
        self.foodShape = SCNPlane(width: 0.05, height: 0.05)
        self.foodNode = SCNNode(geometry:foodShape)
        self.foodShape?.firstMaterial?.diffuse.contents = image
        
        super.init()
        
    }

    
    func loadObjects() {
        
        backgroundNode?.name = "background"
        wrapperNode?.addChildNode(backgroundNode!)
        
        foodwrapperNode?.position = SCNVector3Make((wrapperNode?.position.x)!, (wrapperNode?.position.y)!, (wrapperNode?.position.z)! + 0.001)
        wrapperNode?.addChildNode(foodwrapperNode!)
        
        
        foodNode?.name = randomFoodName
        foodwrapperNode?.addChildNode(foodNode!)
    
        self.addChildNode(wrapperNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
