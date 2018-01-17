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
import AVFoundation

//if a navigation back to HomeScreenViewController is needed, add:
// self.navigationController?.isNavigationBarHidden = false
//to viewWillDisappear??

//current food that is requested
//var currentRequest: String! = nil

//amount of correct items that the user has already tapped
var correctSelected = 0
var currentLocation: SCNVector3 = SCNVector3Make(0, 0, 0)

class GameViewController: UIViewController, ARSCNViewDelegate {
    
    var audioPlayer = AVAudioPlayer()
    

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
    var animations = [String: CAAnimation]()
    var idle: Bool = true
    

    //create request progress view
    var requestProgressView = RequestProgressView()
    
    //create instructions view
    var instructionsView = InstructionsView()
    
    
    //let requestPlane = RequestPlane()
    var request = Request()
   
    var requestNode: SCNNode?
    
    // Variables pertaining to the food request
    var randomFoodNumber: Int!
    var numberOfFoodsRequested: Int!
    var currentRequest: String!
    
    var firstLoad: Bool = true
    
    func playBackground(){
        let backgroundSongPath = Bundle.main.path(forResource: "backgroundSong.mp3", ofType:nil)!
        let backgroundSongURL = URL(fileURLWithPath: backgroundSongPath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundSongURL)
            audioPlayer.volume = 0.5
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
            print ("backgroundmusic on")
        } catch {
            // couldn't load file :(
        }
    }

    func playSwoosh(seconds: Double){
        let swooshPath = Bundle.main.path(forResource: "swoosh.mp3", ofType:nil)!
        let swooshURL = URL(fileURLWithPath: swooshPath)
        
        do {
            self.self.audioPlayer = try AVAudioPlayer(contentsOf: swooshURL)
//            let seconds = 0.7//Time To Delay
            let when = DispatchTime.now() + seconds
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.audioPlayer.play()
            }
            print ("audio played")
        } catch {
            // couldn't load file :(
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sceneView.frame = self.view.frame
        view.addSubview(sceneView)
        
        view.addSubview(instructionsView)
        
        
        UIView.animate(withDuration: 1, delay: 0.7,
                                   usingSpringWithDamping: 0.55,
                                   initialSpringVelocity: 0.3,
                                   options: .curveEaseInOut, animations:  {
            self.playSwoosh(seconds: 0.7)
            self.instructionsView.frame.origin.y -= 200
            
        }, completion: nil)
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
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

        let bunnyScene = SCNScene(named: "art.scnassets/bunnyIdle.dae")!
        bunnyNode = bunnyScene.rootNode.childNode(withName: "Bunny", recursively: true)!
        
        loadAnimation(withKey: "nope", sceneName: "art.scnassets/bunnyNope", animationIdentifier: "bunnyNope-1")
        loadAnimation(withKey: "happy", sceneName: "art.scnassets/bunnyHappy", animationIdentifier: "bunnyHappy-1")
        
        
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
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
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
            planeGeometry.cornerRadius = 50.0
            let planeNode = SCNNode(geometry: planeGeometry)
            
            let grassImage = UIImage(named: "grass")
            let grassMaterial = SCNMaterial()
            grassMaterial.diffuse.contents = grassImage
            grassMaterial.isDoubleSided = true
            planeGeometry.materials = [grassMaterial]
            planeNode.opacity = 0.8
            
            planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
            //            since SCNPlane is vertical, needs to be rotated -90 degress on X axis to make a plane
            planeNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, animations: {
                    self.instructionsView.frame.origin.y += 200
                }, completion: nil)
                UIView.animate(withDuration: 0.5, delay: 0.3,
                               usingSpringWithDamping: 0.55,
                               initialSpringVelocity: 0.3,
                               options: .curveEaseInOut, animations: {
                                
                    self.playSwoosh(seconds: 0.3)
                                
                                //AUDIO INSTRUCTION
//                    let sharePath = Bundle.main.path(forResource: "shareVoice.mp3", ofType:nil)!
//                    let shareURL = URL(fileURLWithPath: sharePath)
//
//                    do {
//                        self.audioPlayer = try AVAudioPlayer(contentsOf: shareURL)
//                        self.audioPlayer.volume = 0.5
//                        self.audioPlayer.numberOfLoops = -1
//                        self.self.audioPlayer.play()
//                        print ("backgroundmusic on")
//                    } catch {
//                        // couldn't load file :(
//                    }
                    self.instructionsView.label.text = "Tap on the grass to find the bunny!"
                    self.instructionsView.frame.origin.y -= 200
                }, completion: nil)
            }
            
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
        UIView.animate(withDuration: 0.1, animations: {
            self.instructionsView.frame.origin.y += 200
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut, animations: {
                        self.playSwoosh(seconds: 0.3)
                        self.instructionsView.label.text = "Move around and tap on the food that the bunny is thinking about!"
                        self.instructionsView.frame.origin.y -= 200
        }, completion: nil)
        
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
                    playAnimation(key: "happy")
                    //audio - set file name & extension
                    let successPath = Bundle.main.path(forResource: "successSound.mp3", ofType:nil)!
                    let successURL = URL(fileURLWithPath: successPath)
                    
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: successURL)
                        audioPlayer.play()
                        print ("audio played")
                    } catch {
                        // couldn't load file :(
                    }
                        
                    correctSelected += 1
                    print(numberOfFoodsRequested)
                    print("you have: \(String(describing: correctSelected)) out of \(String(describing: numberOfFoodsRequested))")
                    requestProgressView.label.text = String(correctSelected) + " / " + String(numberOfFoodsRequested)
                    
                        
                    if correctSelected == numberOfFoodsRequested {
                        
                        
                        print ("Request Complete!")
                        
                        UIView.animate(withDuration: 0.1, animations: {
                            self.instructionsView.frame.origin.y += 200
                        }) { _ in
                            self.instructionsView.removeFromSuperview()
                        }
                        
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
                    //audio - set file name & extension
                    let mistakePath = Bundle.main.path(forResource: "mistakeSound.mp3", ofType:nil)!
                    let mistakeURL = URL(fileURLWithPath: mistakePath)
                    
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: mistakeURL)
                        audioPlayer.play()
                        print ("audio played")
                    } catch {
                        // couldn't load file :(
                    }
                    print(foods[randomFoodNumber!])
                    print(numberOfFoodsRequested)
                    playAnimation(key: "nope")
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
                        //audio - set file name & extension
                        let bunnyAppearPath = Bundle.main.path(forResource: "bunnyAppearSound.mp3", ofType:nil)!
                        let bunnyAppearURL = URL(fileURLWithPath: bunnyAppearPath)
                        
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: bunnyAppearURL)
                            audioPlayer.play()
                            print ("audio played")
                        } catch {
                            // couldn't load file :(
                        }
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

