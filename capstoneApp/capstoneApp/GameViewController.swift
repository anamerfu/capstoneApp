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

//current food that is requested
var currentRequest: String! = nil

//amount of correct items that the user has alread tapped
var correctSelected = 0

class GameViewController: UIViewController, ARSCNViewDelegate {

    let sceneView: ARSCNView = ARSCNView()
    var numberOfObjects = 4
    var bunnyDidAppear = false
//    var bunnyWrapperNode = SCNNode()
//    let bunnyScene = SCNScene(named: "art.scnassets/Bunny.scn")
//    let bunnyNode = "bunny"
//    var bunnyModel:SCNNode!
//    let bunnyName = "Bunny07"
    var planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var nodes = [SCNNode]()
    var planeNodesCount = 0
    var planeHeight: CGFloat = 0.01
    var disableTracking = false
    var isPlaneSelected = false

    var bunnyNode: SCNNode?
    
    //create food request view
    let foodRequestView = FoodRequestView()
    
    


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = self.view.frame
        view.addSubview(sceneView)
        
        foodRequestView.frame = CGRect(x: 20 , y: 20, width: 40, height:40 )
        view.addSubview(foodRequestView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = .multisampling4X
        
        // Create a new scene
        let scene = SCNScene()
      
        // Set the scene to the view
        sceneView.scene = scene
        
        setUpScenesAndNodes()
    }
    
    func setUpScenesAndNodes() {
        // load the lamp model from scene
        let bunnyScene = SCNScene(named: "art.scnassets/Bunny.scn")!
        bunnyNode = bunnyScene.rootNode.childNode(withName: "Bunny07", recursively: true)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if disableTracking {
            return nil
        }
        var node:  SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
        
            let planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            //            since SCNPlane is vertical, needs to be rotated -90 degress on X axis to make a plane
            planeNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
            
        } else {
            // haven't encountered this scenario yet
            print("not plane anchor \(anchor)")
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        planeNodesCount += 1
//        if node.childNodes.count > 0 && planeNodesCount % 2 == 0 {
//            node.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if disableTracking {
            return
        }
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
                    if let plane = planeNode.geometry as? SCNBox {
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.length = CGFloat(planeAnchor.extent.z)
                        plane.height = planeHeight
                    }
                }
            }
        }
    }
    
    
    
    
    func addObject(){
        let object = Object()
        object.loadModel(object: currentRequest)
        
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
            let hitResultsFoods = sceneView.hitTest(location, options:nil)
            let hitResultsBunny = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            if let hitObjectFood = hitResultsFoods.first  {
                
                let node = hitObjectFood.node
                
                let hitObjectBunny = hitResultsBunny.first
                
                if foods.contains(node.name!){
                    
                    //checks if item selected is an item that is requested
                    if node.name == currentRequest {
                        print("correct item selected")
                        correctSelected += 1
                        
                        if correctSelected == currentRequestNumber {
                            print ("Request Complete!")
                        }
                        
                    } else {
                        print("incorrect item selected")
                    }
                    
                    node.removeFromParentNode()
                } else if hitResultsBunny.count > 0 {
                    //do the bunny stuff
                    let result: ARHitTestResult = hitResultsBunny.first!
                    
                    let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                    let newBunnyNode = bunnyNode?.clone()
                    if let newBunnyNode = newBunnyNode {
                        newBunnyNode.position = newLocation
                        sceneView.scene.rootNode.addChildNode(newBunnyNode)
                    }
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
