//
//  AnimatedRig.swift
//  AR Monster Battle
//
//  Created by Takashi Wickes on 2/1/18.
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
	
	static let allValues = [Standing, Faint, Hit, Intro, Attack_1]
}

class AnimatedRig {
    let node: SCNNode
	let daeName: String
    var animations = [String: CAAnimation]()
	var crayAnimations = [String: [CAAnimation]]()
    
    init(modelNamed: String, daeNamed: String){
		self.daeName = daeNamed
		
        let sceneSource = AnimatedRig.getSceneSource(directoryName: self.daeName, fileName: "Standing")
		print(sceneSource?.identifiersOfEntries(withClass: SCNNode.self))
		node = (sceneSource?.scene(options: nil, statusHandler: nil)?.rootNode)!

        //Find and add the armature
		guard let armature = sceneSource?.entryWithIdentifier("Armature", withClass: SCNNode.self) else {
			print("FUDGE")
			return
		}
		
		node.removeAllAnimations()

//        armature.removeAllAnimations()
//        armature.name = "armature"
//        node.addChildNode(armature)
		
        //store and trigger the "rest" animation
//		loadAnimation(withKey: "rest", daeNamed: self.daeName + , repeating: true)
		loadMonsterAnimations(sceneSource: sceneSource!)
		playAnimation(named: .Standing)
//        playAnimation(named: "Standing")
    }
	
	static func getModelScene(daeNamed: String) -> SCNScene? {
		let modelSCN = SCNScene(named: "\(daeNamed)Standing.scn", inDirectory: "art.scnassets/\(daeNamed)", options: nil)
		return modelSCN
	}
    
	static func getSceneSource(directoryName: String, fileName: String) -> SCNSceneSource? {
		guard let collada = Bundle.main.url(forResource: "art.scnassets/\(directoryName)/\(directoryName + fileName)", withExtension: "dae") else {
			print("Files could not be found for " + "art.scnassets/\(directoryName)/\(directoryName + fileName)")
			return nil
		}
        let sceneSource = SCNSceneSource(url: collada, options: nil)!
		print(sceneSource)
        return sceneSource
    }
	
	func loadAnimation(animationName: String, fade: CGFloat = 0.3, repeating: Bool = false){
		let sceneSource = AnimatedRig.getSceneSource(directoryName: self.daeName, fileName: animationName)
//		print("Loading animation for Scene " + animationName)
//		print(sceneSource?.identifiersOfEntries(withClass: CAAnimation.self))
		let animationScene = sceneSource?.scene(options: nil, statusHandler: nil)
		
//		let sceneAnimationKeys = sceneSource?.identifiersOfEntries(withClass: CAAnimation.self)
		let sceneAnimationKeys = animationScene?.rootNode.animationKeys

		print(sceneAnimationKeys?.isEmpty)
		for key in sceneAnimationKeys! {
			print("Grabbing for the key " + key)
			let newAnimation = animationScene?.rootNode.animation(forKey: key)
			animations[animationName] = newAnimation
		}
//		crayAnimations[animationName] = newAnimations
//		guard let animation = sceneSource?.entryWithIdentifier("\(self.daeName)\(animationName)-1", withClass: CAAnimation.self) else {
//			print("Animation could not be found at " + "\(self.daeName)\(animationName)-1")
//			return
//		}
//		if !repeating {
//			animation.repeatCount = 0
//		}
//		animation.usesSceneTimeBase = false
//		animation.fadeInDuration = fade
//		animation.fadeOutDuration = fade
//		animations[animationName] = animation
	}
	
	func loadMonsterAnimations(sceneSource: SCNSceneSource) {
		for animationStateName in MonsterAnimationStates.allValues {
			loadAnimation(animationName: animationStateName.rawValue)
		}
	}
	
    public func playAnimation(named: String, terminateAnimation: Bool = false) { //also works for armature
        if let animation = animations[named] {
			node.childNode(withName: "armature", recursively: true)?.addAnimation(animation, forKey: named)
        }
    }
	
	public func playAnimation(named: MonsterAnimationStates, terminateAnimation: Bool = false) { //also works for armature
		if let animation = animations[named.rawValue] {
			print("Playing Animations for " + named.rawValue)
//			node.removeAllAnimations()
//			node.addAnimation(animation, forKey: named.rawValue)
			node.removeAllAnimations()
			node.addAnimation(animation, forKey: named.rawValue)
//			print(node.childNode(withName: "Armature", recursively: true)?.animationKeys)
		}
	}
    
    func stopAnimation(named: String) {
        if let animation = animations[named] {
            node.removeAnimation(forKey: named)
        }
    }
}

