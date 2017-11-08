//
//  Object.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-05.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import ARKit

class Object: SCNNode {

    func loadModel(object:String) {

        //request objected
        guard let requestedObjectScene = SCNScene(named: "art.scnassets/" + object + ".dae") else {return}

        let wrapperNode = SCNNode()
        

        wrapperNode.name = object
        
        for child in requestedObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }

        self.addChildNode(wrapperNode)
        
    }

}
