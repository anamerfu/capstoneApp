//
//  Bunny.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-04.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import ARKit

class Bunny: SCNNode {
    
    func loadModel() {
        guard let bunnyScene = SCNScene(named: "art.scnassets/Bunny.scn") else {return}

        let wrapperNode = SCNNode()

        for child in bunnyScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }

        self.addChildNode(wrapperNode)

    }
    

}
