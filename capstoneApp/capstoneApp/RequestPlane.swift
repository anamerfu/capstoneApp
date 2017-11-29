//
//  requestPlane.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-11-28.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RequestPlane: SCNPlane {
    
    var image: UIImage?
    var planeShape: SCNPlane?
    var requestNode: SCNNode?
    var requestMaterial:SCNMaterial?
    
    override init(){
        //self.image = UIImage(named: "apple.png")
        self.planeShape = SCNPlane(width: 0.5, height: 0.5)
        self.requestNode = SCNNode(geometry: planeShape)
        //self.planeShape?.firstMaterial?.diffuse.contents = image
        super.init()
    }
    

    func loadFoods(){
       
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
