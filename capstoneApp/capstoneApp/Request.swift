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
        self.backgroundShape = SCNPlane(width: 0.5, height: 0.5)
        self.backgroundNode = SCNNode(geometry: backgroundShape)
        //self.planeShape?.firstMaterial?.diffuse.contents = image
        self.wrapperNode = SCNNode()
        
        super.init()
    }

    
    func loadObjects() {
        
        //guard let requestedObjectScene = SCNScene() else { return }
    
        //let backgroundNode = SCNNode()
    
        //var wrapperNode: SCNNode?
        
        backgroundNode?.name = "background"
        
//        for child in requestedObjectScene.rootNode.childNodes {
//        wrapperNode.addChildNode(child)
//        }
        wrapperNode?.addChildNode(backgroundNode!)
        self.addChildNode(wrapperNode!)
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
