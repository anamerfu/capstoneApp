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
        
        let wrapperNode = SCNNode(geometry: object)
        
        //sphere's do not have root nodes, so it doesn't work rn
//        for child in object.rootNode.childNodes {
//            wrapperNode.addChildNode(child)
//        }
//
        self.addChildNode(wrapperNode)
        
    }

}
