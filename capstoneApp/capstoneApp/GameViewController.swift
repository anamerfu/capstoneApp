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

//amount of correct items that the user has alread tapped
var correctSelected = 0

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

    //create food request view
    let foodRequestView = FoodRequestView()
    
    //create request progress view
    let requestProgressView = RequestProgressView()
    
    let requestPlane = RequestPlane()

   
    var requestNode: SCNNode?

    
    
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
        
        //var requestNode = requestPlane.requestNode
        setUpScenesAndNodes()
        
        //loadAnimations()
    }
    
    func setUpScenesAndNodes() {

        // load the lamp model from scene
        let bunnyScene = SCNScene(named: "art.scnassets/bunnyTestFixed.dae")!
        bunnyNode = bunnyScene.rootNode.childNode(withName: "Bunny", recursively: true)!
//        for child in bunnyScene.rootNode.childNodes {
//            bunnyNode?.addChildNode(child)
//        }
        
        loadAnimation(withKey: "idle", sceneName: "art.scnassets/bunnyTestFixed", animationIdentifier: "Idle")
        
        
        let planeShape = requestPlane.planeShape
        let requestNode = requestPlane.requestNode
        //sceneView.scene.rootNode.addChildNode(planeNode)
        
        
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
//        foodRequestView.frame = CGRect(x: 20 , y: 20, width: 40, height:40 )
//        foodRequestView.addNewRequest()
//        view.addSubview(foodRequestView)
        
//        loadNewObjects()
        
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
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
////        planeNodesCount += 1
////        if node.childNodes.count > 0 && planeNodesCount % 2 == 0 {
////            node.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
////        }
//    }
    
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
    
    
    
    
    func addObject(item:String){
        let object = Object()
        
        object.loadModel(object: item)
        
        let xPos = randomPosition(lowerBound: -3, upperBound: 8)
        let yPos = randomPosition(lowerBound: -3, upperBound: 0.5)
        let zPos = randomPosition(lowerBound: -5, upperBound: 2)
        
        object.position = SCNVector3(xPos, yPos, zPos)
        
        sceneView.scene.rootNode.addChildNode(object)
    }
    
    func loadNewRequest(){

        //removes old 2D images
        for view in foodRequestView.subviews {
            view.removeFromSuperview()
        }
        
        //reset properties
        foodRequestView.setNewProperty()
        
        print("requested \(foodRequestView.numberOfFoodsRequested) \(foods[foodRequestView.randomFoodNumber])" )
        
        //adds new 2D icons
        foodRequestView.frame = CGRect(x: 20 , y: 20, width: 40, height:40 )
        foodRequestView.addNewRequest()
        
        
        //adds new foodRequestView 
        view.addSubview(foodRequestView)
//        requestProgressView.label.text = "\0 / " + String(foodRequestView.numberOfFoodsRequested)
        requestProgressView.label.text = String(correctSelected) + " / " + String(foodRequestView.numberOfFoodsRequested)
        view.addSubview(requestProgressView)
        
        
        loadNewObjects()

    }
    
    func loadNewObjects(){
        
        print(sceneView.scene.rootNode.childNodes)
        
        //removes all 3D objects
        for each in sceneView.scene.rootNode.childNodes {
            if each.name != "Bunny" {
             each.removeFromParentNode()
            }

        }
        
        //creates new array from foods array that doesn't include the current request
        var newfoodArray: Array = foods.filter {$0 != foodRequestView.currentRequest}
        
        //adds the correct 3D objects
        if let numberOfFoodsRequested = foodRequestView.numberOfFoodsRequested {
            for _ in 0..<numberOfFoodsRequested{
                addObject(item:foodRequestView.currentRequest)
                
            }
        }
        
        //adds some random objects
        for _ in 0..<5 {
            let randomFoodNumber = Int (arc4random_uniform ( UInt32(newfoodArray.count) ) )
            let randomObject = newfoodArray[randomFoodNumber]
            addObject(item: randomObject)
        }
        
    }
    
    func randomPosition(lowerBound lower:Float, upperBound upper:Float) -> Float {
       return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 1
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            bunnyAnimations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        sceneView.scene.rootNode.addAnimation(bunnyAnimations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
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
                    if node?.name == foodRequestView.currentRequest {
                    
                    print("correct item selected")
                    correctSelected += 1
                    print(foodRequestView.numberOfFoodsRequested)
                    print("you have: \(String(describing: correctSelected)) out of \(String(describing: foodRequestView.numberOfFoodsRequested))")
                    requestProgressView.label.text = String(correctSelected) + " / " + String(foodRequestView.numberOfFoodsRequested)
                    
                        
                    if correctSelected == foodRequestView.numberOfFoodsRequested {
                        print ("Request Complete!")
                        correctSelected = 0
                        loadNewRequest()
                        loadNewObjects()
                    }
                    
                } else {
                    print("incorrect item selected")
                    print(foods[foodRequestView.randomFoodNumber!])
                    print(foodRequestView.numberOfFoodsRequested)
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
                    let newRequestNode = requestNode
                    
                    if let newBunnyNode = newBunnyNode{
                        
                        print("adding bunny worked")
                        newBunnyNode.position = newLocation
                        sceneView.scene.rootNode.addChildNode(newBunnyNode)
                        loadNewRequest()
                        
                       
                    }
                    
                    if let newRequestNode = newRequestNode {
                        print("adding plane worked")
                        newRequestNode.position = SCNVector3Make(newLocation.x, newLocation.y + 1, newLocation.z)
                        sceneView.scene.rootNode.addChildNode(newRequestNode)
                        
                    } else {
                        print (newRequestNode)
                        print ("not true")
                    }
                }
            }
            }
            }
        }
//        loadNewObjects()
    

  
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

