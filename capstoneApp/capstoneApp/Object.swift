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
        
        let randomFoodNumber = Int (arc4random_uniform ( UInt32(foods.count) ) )
        let nodeName = foods[randomFoodNumber]
    
        
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/" + nodeName + ".dae") else {return}
        
        let wrapperNode = SCNNode()
        
        wrapperNode.name = nodeName
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }

        self.addChildNode(wrapperNode)
        
    }

}
