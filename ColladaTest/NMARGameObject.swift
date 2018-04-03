//
//  GameObject.swift
//  AR Monster Battle
//
//  Created by Nicholas Miller on 11/20/17.
//  Copyright © 2017 nickbryanmiller. All rights reserved.
//
import SceneKit

protocol NMARGameObject: class {
	func getSCNNode() -> SCNNode?
	func getID() -> String?
	func getNodeName() -> String?
	func getWidth() -> Float?
	func getHeight() -> Float?
	func getTransform() -> SCNMatrix4?
	func getSIMDTransform() -> simd_float4x4?
	func getSIMDWorldTransform() -> simd_float4x4?
	func getWorldOrientation() -> SCNQuaternion?
	func getWorldPosition() -> SCNVector3?
	func set(worldPosition: SCNVector3)
	func set(transform: SCNMatrix4)
	func set(simdTransform: simd_float4x4)
	func set(simdWorldTransform: simd_float4x4)
	func set(worldOrientation: SCNQuaternion, worldPosition: SCNVector3)
	func removeFromParent()
}

extension NMARGameObject {
	var idAsUInt32: UInt32? {
		get {
			guard let id = getID() else { return nil }
			return UInt32(id)
		}
	}
	
//	func updateToMatchGameObjectUpdate(message: BluetoothMessage, completion: (() -> Void)? = nil) {
//		guard let payloadData = message.getPayloadData() else {
//			print("no payload")
//			return
//		}
//		print(payloadData)
//		
//		guard let objIDData = payloadData.copyBytes(start: 0, end: 4) else { return }
//		guard let objID = objIDData.toUInt32() else { return }
//		let objIDString = "\(objID)"
//		if objIDString != getID() { return }
//		
//		// take out position and orientation
//		// min payload byte size is: monsterID (4) + position (12) + orientation (16) + optional animation state = 32
//		if payloadData.count < 31 { return }
//		
//		guard let posXData = payloadData.copyBytes(start: 4, end: 8) else { return }
//		guard let posX32 = posXData.toFloat32() else { return }
//		let posX = Float(posX32)
//		guard let posYData = payloadData.copyBytes(start: 8, end: 12) else { return }
//		guard let posY32 = posYData.toFloat32() else { return }
//		var posY = Float(posY32)
//		guard let posZData = payloadData.copyBytes(start: 12, end: 16) else { return }
//		guard let posZ32 = posZData.toFloat32() else { return }
//		let posZ = Float(posZ32)
//		
//		// may need to be changed
//		if let height = getHeight() { posY = posY + height/2 }
//		
//		var position = SCNVector3()
//		position.x = posX
//		position.y = posY
//		position.z = posZ
//		
//		guard let orientationXData = payloadData.copyBytes(start: 16, end: 20) else { return }
//		guard let orientationX32 = orientationXData.toFloat32() else { return }
//		let orientationX = Float(orientationX32)
//		guard let orientationYData = payloadData.copyBytes(start: 20, end: 24) else { return }
//		guard let orientationY32 = orientationYData.toFloat32() else { return }
//		let orientationY = Float(orientationY32)
//		guard let orientationZData = payloadData.copyBytes(start: 24, end: 28) else { return }
//		guard let orientationZ32 = orientationZData.toFloat32() else { return }
//		let orientationZ = Float(orientationZ32)
//		guard let orientationWData = payloadData.copyBytes(start: 28, end: 32) else { return }
//		guard let orientationW32 = orientationWData.toFloat32() else { return }
//		let orientationW = Float(orientationW32)
//		
//		var orientation = SCNQuaternion()
//		orientation.x = orientationX
//		orientation.y = orientationY
//		orientation.z = orientationZ
//		orientation.w = orientationW
//		
//		// set position and orientation
//		set(worldOrientation: orientation, worldPosition: position)
//		
//		// get animation state and set this monster to that
//		
//		// call completion block
//		if let completion = completion { completion() }
//	}
//	
//	func updateFromGameObjectAttack(message: BluetoothMessage, completion: ((String, Int) -> Void)? = nil) {
//		
//		// parse message and apply attack damage
//		guard let payloadData = message.getPayloadData() else {
//			print("no payload")
//			return
//		}
//		
//		guard let enemyObjIDData = payloadData.copyBytes(start: 0, end: 4), let enemyObjID = enemyObjIDData.toUInt32() else {
//			print("no enemy monster id")
//			return
//		}
//		let enemyObjIDString = "\(enemyObjID)"
//		
//		guard let myObjIDData = payloadData.copyBytes(start: 4, end: 8), let myObjID = myObjIDData.toUInt32() else {
//			print("no my monster id")
//			return
//		}
//		let myObjIDString = "\(myObjID)"
//		if getID() != myObjIDString {
//			print("my monster id strings do not match")
//			print("the received monster id: \(myObjIDString)")
//			print("the one i have: \(String(describing: getID()))")
//			return
//		}
//		
//		guard let damageDealtData = payloadData.copyBytes(start: 8, end: 10), let damageDealt = damageDealtData.toUInt16() else {
//			print("no damageDealt")
//			return
//		}
//		
//		// set damage dealt in current obj
//		
//		// call completion block
//		if let completion = completion { completion(enemyObjIDString, Int(damageDealt)) }
//	}
}
