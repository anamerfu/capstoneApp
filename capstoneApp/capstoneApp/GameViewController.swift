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
import SpriteKit

//if a navigation back to HomeScreenViewController is needed, add:
// self.navigationController?.isNavigationBarHidden = false
//to viewWillDisappear??

//current food that is requested
//var currentRequest: String! = nil

//amount of correct items that the user has already tapped
var correctSelected = 0
var currentLocation: SCNVector3 = SCNVector3Make(0, 0, 0)

class GameViewController: UIViewController, ARSCNViewDelegate {

    let sceneView: ARSCNView = ARSCNView()

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
    var correctSelected = 0

    var bunnyNode: SCNNode?
    var bunnyAnimations = [String: CAAnimation]()
    var idle: Bool = true
    

    //create request progress view
    var requestProgressView = RequestProgressView()
    
    //let requestPlane = RequestPlane()
    var request = Request()
   
    var requestNode: SCNNode?
    
    // Variables pertaining to the food request
    var randomFoodNumber: Int!
    var numberOfFoodsRequested: Int!
    var currentRequest: String!
    
    var firstLoad: Bool = true

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = self.view.frame
        view.addSubview(sceneView)
        

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
        
        //add info from Request.swift to this views variables
        randomFoodNumber = request.randomFoodNumber
        numberOfFoodsRequested = request.numberOfFoodsRequested
        currentRequest = request.currentRequest
        
        setUpScenesAndNodes()
        setUpRequestNodes()
        
        //loadAnimations()
    }
    
    func setUpScenesAndNodes() {

        let bunnyScene = SCNScene(named: "art.scnassets/bunnyTestFixed.dae")!
        bunnyNode = bunnyScene.rootNode.childNode(withName: "Bunny", recursively: true)!

     
    }
    
    func setUpRequestNodes () {
        
        request.loadObjects()
        requestNode = request.backgroundNode

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)

        //loadNewObjects()

        
        
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
            
            let grassImage = UIImage(named: "grass")
            let grassMaterial = SCNMaterial()
            grassMaterial.diffuse.contents = grassImage
            grassMaterial.isDoubleSided = true
            
            planeGeometry.materials = [grassMaterial]
            
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
    

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if disableTracking {
            return
        }
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count == 1 {
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
    
    func addProgressView () {
        //let requestProgressView = RequestProgressView()
        requestProgressView.label.text = String(correctSelected) + " / " + String(numberOfFoodsRequested)
        view.addSubview(requestProgressView)
        
    }
    
    func loadNewObjects(){
        
        print(sceneView.scene.rootNode.childNodes)

        //creates new array from foods array that doesn't include the current request
        var newfoodArray: Array = foods.filter {$0 != currentRequest}
        
        //adds the correct 3D objects
        if let numberOfFoodsRequested = numberOfFoodsRequested {
            for _ in 0..<numberOfFoodsRequested{
                RequestHelper.addObject(sceneView: sceneView, item: currentRequest)
                
                
            }
        }
        
        //adds some random objects
        for _ in 0..<5 {
            let randomFoodNumber = Int (arc4random_uniform ( UInt32(newfoodArray.count) ) )
            let randomObject = newfoodArray[randomFoodNumber]
                RequestHelper.addObject(sceneView: sceneView, item: randomObject)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan running")
        if let touch = touches.first {
            
            let location = touch.location(in: sceneView)
            let hitResultsFoods = sceneView.hitTest(location, options: nil)
            let resultFood: SCNHitTestResult? = hitResultsFoods.first
            
            
            if resultFood != nil {
                let node = resultFood?.node
           
            
                if node?.name != nil {
                
                //checks if item selected is an item that is requested
                    print("user selected \(String(describing: node?.name))")
                    if node?.name == currentRequest {
                    
                    print("correct item selected")
                    correctSelected += 1
                    print(numberOfFoodsRequested)
                    print("you have: \(String(describing: correctSelected)) out of \(String(describing: numberOfFoodsRequested))")
                    requestProgressView.label.text = String(correctSelected) + " / " + String(numberOfFoodsRequested)
                    
                        
                    if correctSelected == numberOfFoodsRequested {
                        print ("Request Complete!")
                        correctSelected = 0
                        request = Request()
                        
                        
                        RequestHelper.removeOldRequestNodes(sceneView: sceneView)
                        
                        setUpRequestNodes()
                        
                        RequestHelper.loadRequestBubble(sceneView: sceneView, node: request.wrapperNode!, location: currentLocation)
                        
                        currentRequest = foods[request.randomFoodNumber!]
                        numberOfFoodsRequested = request.numberOfFoodsRequested
                        loadNewObjects()
                        
                        requestProgressView = RequestProgressView()
                        addProgressView()
                        view.addSubview(requestProgressView)
                        print("new current request: \(currentRequest)")
                        
                        
                        
                    }
                    
                } else {
                    print("incorrect item selected")
                    print(foods[randomFoodNumber!])
                    print(numberOfFoodsRequested)
                }
                    if foods.contains((node?.name)!) {
                     node?.removeFromParentNode()
                    }
                
            } else {
                //put bunny on the plane detected
                let hitResultsBunny = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
                let result: ARHitTestResult = hitResultsBunny.first!
                
                if hitResultsBunny.count > 0 {
                    let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                    
                    
                    let newBunnyNode = bunnyNode
                    let newRequestNode = request.wrapperNode
                    if let newBunnyNode = newBunnyNode{
                        
                        print("adding bunny worked")
                        newBunnyNode.position = newLocation
                        sceneView.scene.rootNode.addChildNode(newBunnyNode)

                       
                    }
                    
                    if let newRequestNode = newRequestNode {
                        print("adding plane worked")
                        RequestHelper.loadRequestBubble(sceneView: sceneView, node: newRequestNode, location: newLocation)
                        currentLocation = newLocation
                        if firstLoad {
                            loadNewObjects()
                            addProgressView()
                            firstLoad = false
                        }
                        
                    } else {
                        print ("not true")
                    }
                    
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

