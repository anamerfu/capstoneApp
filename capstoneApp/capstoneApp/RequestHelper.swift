//
//  RequestHelper.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-12-10.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
import SceneKit

class RequestHelper {
    class func loadRequestBubble(sceneView: SCNView, node: SCNNode, location: SCNVector3) {
        node.position = SCNVector3Make(location.x, location.y + 0.6, location.z)
        sceneView.scene?.rootNode.addChildNode(node)
        

    }
}
