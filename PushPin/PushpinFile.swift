//
//  PushpinFile.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation
import UIKit

@objc
class PushpinFile: NSObject, NSCoding {

	let fileName: String
	var lastModified: NSDate
	let pinManager: PinManager
	var drawnLines: [Vector]
	var sameTouch = false
	var hasBeenDeleted = false
	
	init(fileName: String, lastModified: NSDate) {
		self.fileName = fileName
		self.lastModified = lastModified
		self.pinManager = PinManager()
		self.drawnLines = [Vector]()
	}
	
	func addDrawnLine(start: CGPoint, _ end: CGPoint, _ straight: Bool = false) {
		if let last = drawnLines.last {
			if sameTouch {
				if straight {
					drawnLines.removeLast()
					let newVector = Vector(last.x1, last.y1, Double(end.x), Double(end.y))
					drawnLines.append(newVector)
					return
				} else {
					let endToNext = Vector(last.x2, last.y2, Double(end.x), Double(end.y))
					if last.norm.dot(endToNext.norm) > 0.99 {
						drawnLines.removeLast()
						let extend = last.norm
						let newVector = Vector(last.x1, last.y1, last.x2 + extend.xcomp * endToNext.mag, last.y2 + extend.ycomp * endToNext.mag)
						drawnLines.append(newVector)
						return
					} else {
						drawnLines.append(endToNext)
						sameTouch = false
						return
					}
				}
			}
		}
		drawnLines.append(Vector(start, end))
	}

	func removeIntersectingLines(erasePoint: CGPoint) {
		if drawnLines.isEmpty {return}
		var l = 0
		
		//The guy she tells you not to worry about
		func intersecting(line: Vector, _ erasePoint: CGPoint) -> Bool {
			let qX = Double(erasePoint.x), qY = Double(erasePoint.y)
			
			//Endpoint check
			if Vector(qX, qY, line.x1, line.y1).mag < 25 || Vector(qX, qY, line.x2, line.y2).mag < 25 { return true }
			
			//Supersample the vector in diameter-sized intervals
			let lerpInc = 50 / line.mag
			var amt = lerpInc
			//This will run until all super-samples have been completed
			//Never runs on a vector with mag less than 50 px, because if intersection
			//were reasonably possible then the endpoint check would have caught it
			while amt < 1.0 {
				//Get the point for this fraction of the vector
				let p = line.lerped(amt)
				//Check the circle inequality formula
				if pow((p.0 - qX), 2) + pow((p.1 - qY), 2) < pow(25, 2) {
					return true
				}
				//move to the next
				amt += lerpInc
			}
			return false
		}
		
		while l < drawnLines.count {
			if intersecting(drawnLines[l], erasePoint) {
				drawnLines.removeAtIndex(l)
			} else {
				l += 1
			}
		}
	}
	
	func removeInZone(tl: CGPoint, _ br: CGPoint) {
		if drawnLines.isEmpty {return}
		func between(a: Double, b: Double, x: Double) -> Bool {
			return x <= max(a, b) && x >= min(a, b)
		}
		func inZone(v: Vector, _ tl: CGPoint, _ br: CGPoint) -> Bool {
			let tlx = Double(tl.x), tly = Double(tl.y), brx = Double(br.x), bry = Double(br.y)
			return (between(tlx, b: brx, x: v.x1) && between(tly, b: bry, x: v.y1)) || (between(tlx, b: brx, x: v.x2) && between(tly, b: bry, x: v.y2))
		}
		var l = 0
		while l < drawnLines.count {
			if inZone(drawnLines[l], tl, br) {
				drawnLines.removeAtIndex(l)
			} else {
				l += 1
			}
		}
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.fileName, forKey: "fileName")
		aCoder.encodeObject(self.lastModified, forKey: "lastModified")
		aCoder.encodeObject(self.pinManager, forKey: "pinManager")
		aCoder.encodeInt(Int32(self.drawnLines.count), forKey: "numDrawnLines")
		aCoder.encodeBool(hasBeenDeleted, forKey: "hasBeenDeleted")
		var i = 0
		for line in drawnLines {
			aCoder.encodeObject(line, forKey: "line" + String(i))
			i += 1
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.hasBeenDeleted = aDecoder.decodeBoolForKey("hasBeenDeleted")
		if hasBeenDeleted {
			self.fileName = ""
			self.lastModified = NSDate()
			self.pinManager = PinManager()
			self.drawnLines = [Vector]()
		} else {
			self.fileName = aDecoder.decodeObjectForKey("fileName") as! String
			self.lastModified = aDecoder.decodeObjectForKey("lastModified") as! NSDate
			self.pinManager = aDecoder.decodeObjectForKey("pinManager") as! PinManager
			self.drawnLines = [Vector]()
			var i = 0
			while i < Int(aDecoder.decodeIntForKey("numDrawnLines")) {
				drawnLines.append(aDecoder.decodeObjectForKey("line" + String(i)) as! Vector)
				i += 1
			}
		}
	}
	
}
