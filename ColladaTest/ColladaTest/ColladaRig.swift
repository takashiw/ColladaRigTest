//
//  AnimatedRig.swift
//  AR Monster Battle
//
//  Created by Takashi Wickes on 2/1/18.
//  Copyright © 2018 takashiwickes. All rights reserved.
//

import Foundation
import SceneKit

class ColladaRig {
    let rootNode: SCNNode
	let daeName: String
    var animations = [String: CAAnimation]()
//	var crayAnimations = [String: [CAAnimation]]()
	
    init(modelNamed: String, daeNamed: String){
		self.daeName = daeNamed
		
		let idleScene = SCNScene(named: "art.scnassets/" + daeNamed + "/" + daeNamed + "Standing.dae")!
		let node = SCNNode()
		
		for childNode in idleScene.rootNode.childNodes {
			node.addChildNode(childNode)
		}
		
		self.rootNode = SCNNode()
		self.rootNode.addChildNode(node)
		
		self.loadAnimation(withKey: "Standing", sceneName: "art.scnassets/" + daeNamed + "/" + daeNamed + "Standing", animationIdentifier: daeNamed + "Standing-1")
		self.playAnimation(named: .Standing)
		
		self.loadAnimation(withKey: "Attack_1", sceneName: "art.scnassets/" + daeNamed + "/" + daeNamed + "Attack_1", animationIdentifier: daeNamed + "Attack_1-1")
		self.loadAnimation(withKey: "Intro", sceneName: "art.scnassets/" + daeNamed + "/" + daeNamed + "Intro", animationIdentifier: daeNamed + "Intro-1")
		self.loadAnimation(withKey: "Faint", sceneName: "art.scnassets/" + daeNamed + "/" + daeNamed + "Faint", animationIdentifier: daeNamed + "Faint-1")
		self.loadAnimation(withKey: "Hit", sceneName: "art.scnassets/" + daeNamed + "/" + daeNamed + "Hit", animationIdentifier: daeNamed + "Hit-1")
    }
	
	func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
		let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
		let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
		
		if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
			// The animation will only play once
			animationObject.repeatCount = 1
			// To create smooth transitions between animations
			animationObject.fadeInDuration = CGFloat(0)
			animationObject.fadeOutDuration = CGFloat(0)
			
			// Store the animation for later use
			animations[withKey] = animationObject
		}
	}
	
	public func playAnimation(named: MonsterAnimationStates, terminateAnimation: Bool = false) { //also works for armature
		if let animation = animations[named.rawValue] {
			print("Playing Animations for " + named.rawValue)
			rootNode.addAnimation(animation, forKey: named.rawValue)
		}
	}
    
    func stopAnimation(named: String) {
        if let animation = animations[named] {
//            node.removeAnimation(forKey: named)
        }
    }
}

