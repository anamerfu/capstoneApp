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
    var wrapperNode:SCNNode?
    
    var image: UIImage?
    var backgroundShape: SCNPlane?
    var backgroundNode: SCNNode?
    var requestMaterial:SCNMaterial?
    
    var foodNode: SCNNode?
    var foodShape: SCNPlane?
    
    override init() {
        self.image = UIImage(named: "apple.png")
        self.backgroundShape = SCNPlane(width: 0.35, height: 0.2)
        self.backgroundNode = SCNNode(geometry: backgroundShape)
        //self.planeShape?.firstMaterial?.diffuse.contents = image
        self.wrapperNode = SCNNode()
        
        self.foodShape = SCNPlane(width: 0.1, height: 0.1)
        self.foodNode = SCNNode(geometry:foodShape)
        self.foodShape?.firstMaterial?.diffuse.contents = image
        
        super.init()
    }

    
    func loadObjects() {
        
        backgroundNode?.name = "background"
        wrapperNode?.addChildNode(backgroundNode!)
        
        
        foodNode?.name = "food"
        wrapperNode?.addChildNode(foodNode!)
    
        self.addChildNode(wrapperNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
