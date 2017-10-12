//
//  ViewController.swift
//  capstoneApp
//
//  Created by Ana Merfu on 2017-10-04.
//  Copyright © 2017 Ana Merfu & Laura Douglas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

//if a navigation back to HomeScreenViewController is needed, add:
// self.navigationController?.isNavigationBarHidden = false
//to viewWillDisappear??

class GameViewController: UIViewController, ARSCNViewDelegate {

    let sceneView: ARSCNView = ARSCNView()
    
    let numberOfObjects = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = self.view.frame
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
       let scene = SCNScene()
      
        
        // Set the scene to the view
        
        sceneView.scene = scene
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
//        addBunny()
        
        for _ in 0..<numberOfObjects {
            addObject()
            print ("for loop working")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = addBunny(anchor: planeAnchor)
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
        print("renderer func works")
    }
    
    func addBunny(anchor: ARPlaneAnchor) -> SCNNode {
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let bunny = Bunny()
        bunny.loadModel()
        
        bunny.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        
        bunny.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        print("addBunny called")
        return bunny
        
        //        bunny.position = SCNVector3(0, 0, -1)
        //
        //        sceneView.scene.rootNode.addChildNode(bunny)
        //        print ("add bunny worked")
        
        
    }
    
    
    func addObject(){
        let object = Object()
        object.loadModel()
        
        let xPos = randomPosition(lowerBound: -3, upperBound: 3)
        let yPos = randomPosition(lowerBound: -1.5, upperBound: 0.75)
        let zPos = randomPosition(lowerBound: -5, upperBound: -1.5)
        
        object.position = SCNVector3(xPos, yPos, zPos)
        
        sceneView.scene.rootNode.addChildNode(object)
        print ("add object working")
    }
    
    func randomPosition(lowerBound lower:Float, upperBound upper:Float) -> Float {
       return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan running")
        if let touch = touches.first {
            print("if let one")
            let location = touch.location(in: sceneView)
            let hitList = sceneView.hitTest(location, options:nil)
            if let hitObject = hitList.first {
                let node = hitObject.node
                if node.name == "apple"{
                    node.removeFromParentNode()
                }
            }
        }
        
    }
    

    
    //Tests
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
