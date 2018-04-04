//
//  ViewController.swift
//  ColladaTest
//
//  Created by Takashi Wickes on 4/2/18.
//  Copyright © 2018 armonster. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

let kPlaneIndentifier: String = "plane"

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	var attackButton: UIButton!
	var introButton: UIButton!
	var hitButton: UIButton!
	var faintButton: UIButton!

	var colladaRig: ColladaRig!
	var placeHolder: Placeholder!
	
	// MARK: - Private Variables
//	private var sceneView: ARSCNView!
	private var _shouldHidePlanes: Bool = false
	private var nodes: Array<String> = Array<String>()
	private var nmARGameObjs: Array<NMARGameObject?> = Array<NMARGameObject?>()
	
	// MARK: - Public Variables
	public var planes: [UUID : SCNNode?] = [:]
	public var shouldHidePlanes: Bool {
		get { return _shouldHidePlanes }
		set {
			_shouldHidePlanes = newValue
//			updatePlaneVisibility()
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
		if let cameraSetup = SCNScene(named: "art.scnassets/CameraSetup.scn") {
			sceneView.scene = cameraSetup
		} else {
			sceneView.scene = SCNScene()
		}
		
		attackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		attackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(attackButtonTapped)))
		attackButton.backgroundColor = UIColor.red
		attackButton.setTitle("Attack", for: .normal)
		// link this to animations
		self.view.addSubview(attackButton)
		
		introButton = UIButton(frame: CGRect(x: 0, y: 110, width: 100, height: 100))
		introButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(introButtonTapped)))
		introButton.backgroundColor = UIColor.red
		introButton.setTitle("Intro", for: .normal)
		// link this to animations
		self.view.addSubview(introButton)
		
		hitButton = UIButton(frame: CGRect(x: 0, y: 220, width: 100, height: 100))
		hitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hitButtonTapped)))
		hitButton.backgroundColor = UIColor.red
		hitButton.setTitle("Hit", for: .normal)
		// link this to animations
		self.view.addSubview(hitButton)
		
		faintButton = UIButton(frame: CGRect(x: 0, y: 330, width: 100, height: 100))
		faintButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(faintButtonTapped)))
		faintButton.backgroundColor = UIColor.red
		faintButton.setTitle("Faint", for: .normal)
		// link this to animations
		self.view.addSubview(faintButton)
		
		placeHolder = Placeholder(id: "Degault")
    }
	
	@objc private func attackButtonTapped() {
		self.placeHolder.collada?.playAnimation(for: .Attack_1)
	}
	
	
	@objc private func introButtonTapped() {
		self.placeHolder.collada?.playAnimation(for: .Intro)
	}
	
	@objc private func hitButtonTapped() {
		self.placeHolder.collada?.playAnimation(for: .Hit)
	}
	
	
	@objc private func faintButtonTapped() {
		self.placeHolder.collada?.playAnimation(for: .Faint)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal
		configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
	
	func place(obj: NMARGameObject?) {
		guard let node = obj?.getSCNNode() else {
			print("no node for obj")
			return
		}
		
		if let name = obj?.getNodeName() {
			sceneView.scene.rootNode.addChildNode(node)
		}
	}
	
	// MARK: - Touch Events
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touchLocation = touches.first?.location(in: sceneView) {
			
			// Touch to 3D Object (ignoring plane because that is the next test)
			if let hit = sceneView.hitTest(touchLocation, options: nil).first {
				if hit.node.name != kPlaneIndentifier {
					
					return
				}
			}
			
			// Touch to Plane
			if let hit = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent).last {
				// setup and call placeholder
				print("TOUCHED!!! ", touchLocation)
				var worldTransform = hit.worldTransform
				
//				if abs(worldTransform.columns.3.z) > kMaxDistanceUserCanPlaceMonster { return }
//				arCameraView?.remove(obj: placeholder)
				var position = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
//				if let height = placeholder?.getHeight() {
//					print("node height: \(height)")
//					position = SCNVector3(position.x, position.y + (height/2), position.z)
//				}
				worldTransform.columns.3.x = position.x
				worldTransform.columns.3.y = position.y
				worldTransform.columns.3.z = position.z
				
				guard let placeholder = placeHolder else {
					print("no placeholder")
					return
				}

				let worldOri = SCNQuaternion()
				placeholder.set(worldOrientation: worldOri, worldPosition: position)
				self.sceneView.scene.rootNode.addChildNode(placeholder.getSCNNode()!)
				return
			}
		}
	}
	
	/*
	Called when a SceneKit node corresponding to a
	new AR anchor has been added to the scene.
	*/
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		
		// Place plane if anchor is plane anchor.
		if let planeAnchor = anchor as? ARPlaneAnchor {
			// Create a SceneKit plane to visualize the plane anchor using its position and extent.
			let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
			let planeNode = SCNNode(geometry: plane)
			planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
			
			/*
			`SCNPlane` is vertically oriented in its local coordinate space, so
			rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
			*/
			planeNode.eulerAngles.x = -.pi / 2
			
			// Make the plane visualization semitransparent to clearly show real-world placement.
			planeNode.opacity = 0.25
			planeNode.name = kPlaneIndentifier
			
			/*
			Add the plane visualization to the ARKit-managed node so that it tracks
			changes in the plane anchor as plane estimation continues.
			*/
			planes.updateValue(planeNode, forKey: anchor.identifier)
			planeNode.isHidden = shouldHidePlanes
			node.addChildNode(planeNode)
		} else {
			// we should place our selectedModel
//			delegate?.scnNodeForNodeAndFeatureAnchor(sender: self, node: node, anchor: anchor)
		}
	}
	
	/*
	Called when a SceneKit node's properties have been
	updated to match the current state of its corresponding anchor.
	*/
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		// Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
		guard let planeAnchor = anchor as?  ARPlaneAnchor,
			let planeNode = node.childNodes.first,
			let plane = planeNode.geometry as? SCNPlane
			else { return }
		
		// Plane estimation may shift the center of a plane relative to its anchor's transform.
		planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
		
		/*
		Plane estimation may extend the size of the plane, or combine previously detected
		planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
		corresponding node for one plane, then calls this method to update the size of
		the remaining plane.
		*/
		plane.width = CGFloat(planeAnchor.extent.x)
		plane.height = CGFloat(planeAnchor.extent.z)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		self.planes.removeValue(forKey: anchor.identifier)
	}
}
