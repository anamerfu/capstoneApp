//
//  Object.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-05.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import ARKit

class Object: SCNNode {

    func loadModel() {
        let object = SCNSphere(radius:0.2)
        
        object.firstMaterial?.diffuse.contents = UIColor.red
        
        let wrapperNode = SCNNode(geometry: object)
        wrapperNode.name = "sphere"
        
        //sphere's do not have root nodes, so it doesn't work rn
//        for child in object.rootNode.childNodes {
//            wrapperNode.addChildNode(child)
//        }
//
        self.addChildNode(wrapperNode)
        
    }

}
