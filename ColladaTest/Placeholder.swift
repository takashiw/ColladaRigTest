//
//  PlaceHolder.swift
//  AR Monster Battle
//
//  Created by Nicholas Miller on 3/28/18.
//  Copyright © 2018 nickbryanmiller. All rights reserved.
//

import Foundation
import SceneKit

class Placeholder: NMARGameObject {
	
	private var id: String!
	private var myNode: SCNNode?
	public var collada: ColladaRig?
	
	private(set) var wasPlaced: Bool = false
	
	init(id: String) {
		self.id = id
		collada = ColladaRig(daeNamed: "Intro", scale: SCNVector3(0.04, 0.04, 0.04), repeatIdleAnimation: false)
//		collada = ColladaRig(daeNamed: "Pokeball", repeatIdleAnimation: false)
//		collada = ColladaRig(daeNamed: "Squirtle")

	}
	
	func getSCNNode() -> SCNNode? {
		if myNode != nil { return myNode }
		myNode = collada?.rootNode
//		myNode?.scale = SCNVector3Make(0.1, 0.1, 0.1)
		return myNode
	}
	
	func getID() -> String? {
		return id
	}
	
	func getNodeName() -> String? {
		return "Placeholder \(String(describing: getID()))"
	}
	
	func getWidth() -> Float? {
		guard let node = getSCNNode() else {
			print("no node")
			return nil
		}
		return node.boundingBox.max.x - node.boundingBox.min.x
	}
	
	func getHeight() -> Float? {
		guard let node = getSCNNode() else {
			print("no node")
			return nil
		}
		return node.boundingBox.max.y - node.boundingBox.min.y
	}
	
	func getTransform() -> SCNMatrix4? {
		return getSCNNode()?.transform
	}
	
	func getSIMDTransform() -> simd_float4x4? {
		return getSCNNode()?.simdTransform
	}
	
	func getSIMDWorldTransform() -> simd_float4x4? {
		return getSCNNode()?.simdWorldTransform
	}
	
	func getWorldOrientation() -> SCNQuaternion? {
		return getSCNNode()?.worldOrientation
	}
	
	func getWorldPosition() -> SCNVector3? {
		return getSCNNode()?.worldPosition
	}
	
	func set(worldPosition: SCNVector3) {
		self.wasPlaced = true
		getSCNNode()?.worldPosition = worldPosition
	}
	
	func set(transform: SCNMatrix4) {
		self.wasPlaced = true
		getSCNNode()?.transform = transform
	}
	
	func set(simdTransform: simd_float4x4) {
		self.wasPlaced = true
		getSCNNode()?.simdTransform = simdTransform
	}
	
	func set(simdWorldTransform: simd_float4x4) {
		self.wasPlaced = true
		getSCNNode()?.simdWorldTransform = simdWorldTransform
	}
	
	func set(worldOrientation: SCNQuaternion, worldPosition: SCNVector3) {
		self.wasPlaced = true
		getSCNNode()?.worldOrientation = worldOrientation
		getSCNNode()?.worldPosition = worldPosition
	}
	
	func removeFromParent() {
		getSCNNode()?.removeFromParentNode()
	}
}
