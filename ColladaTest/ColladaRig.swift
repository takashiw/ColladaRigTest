//
//  ColladaRig.swift
//  AR Monster Battle
//
//  Created by Takashi Wickes on 4/3/18.
//  Copyright © 2018 takashiwickes. All rights reserved.
//

import Foundation
import SceneKit

enum MonsterAnimationStates: String {
	case Standing
	case Faint
	case Hit
	case Intro
	case Attack_1
	
	static let allValues = [Faint, Hit, Intro, Attack_1]
}

class ColladaRig {
    let rootNode: SCNNode
	let daeName: String
    var animations = [String: CAAnimation]()
	
    init(daeNamed: String){
		self.daeName = daeNamed
		
		let idleScene = SCNScene(named: "art.scnassets/" + daeNamed + "/" + daeNamed + "Standing.dae")!
		let node = SCNNode()
		
		for childNode in idleScene.rootNode.childNodes {
			node.addChildNode(childNode)
		}
		
		self.rootNode = SCNNode()
		self.rootNode.addChildNode(node)
		self.loadMonsterAnimations()
    }
	
	func loadMonsterAnimations() {
		for animationState in MonsterAnimationStates.allValues {
			self.loadAnimation(withKey: animationState.rawValue,
							   sceneName: "art.scnassets/\(daeName)/\(daeName)" + animationState.rawValue,
							   animationIdentifier: daeName + animationState.rawValue + "-1")
		}
	}
	
	func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
		guard let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae") else {
			return
		}
		let sceneSource = SCNSceneSource(url: sceneURL, options: nil)
		
		if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
			print("Animation Found! for " + animationIdentifier)
			// The animation will only play once
			animationObject.repeatCount = 1
			// To create smooth transitions between animations
			animationObject.fadeInDuration = CGFloat(0.3)
			animationObject.fadeOutDuration = CGFloat(0.5)
			
			// Store the animation for later use
			animations[withKey] = animationObject
		} else {
			print("Animation not found for " + animationIdentifier)
		}
	}
	
	public func playAnimation(for state: MonsterAnimationStates, terminateAnimation: Bool = false) { //also works for armature
		if let animation = animations[state.rawValue] {
			print("Playing Animations for " + state.rawValue)
			rootNode.addAnimation(animation, forKey: state.rawValue)
		}
	}
    
    func stopAnimation(for state: MonsterAnimationStates) {
		if let animation = animations[state.rawValue] {
			print("Playing Animations for " + state.rawValue)
			rootNode.removeAnimation(forKey: state.rawValue)
		}
    }
}

