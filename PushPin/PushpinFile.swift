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
	let lastModified: NSDate
	let pinManager: PinManager
	var drawnLines: [Vector]
	var sameTouch = false
	
	init(fileName: String, lastModified: NSDate) {
		self.fileName = fileName
		self.lastModified = lastModified
		self.pinManager = PinManager()
		self.drawnLines = [Vector]()
	}
	
	func addDrawnLine(start: CGPoint, _ end: CGPoint) {
		if let last = drawnLines.last {
			if sameTouch {
				let endToNext = Vector(last.x2, last.y2, Double(end.x), Double(end.y))
				if last.norm.dot(endToNext.norm) > 0.96 {
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
		drawnLines.append(Vector(start, end))
	}

	func removeIntersectingLines(erasePoint: CGPoint) {
		if drawnLines.isEmpty {return}
		var l = 0
		func intersecting(line: Vector, _ erasePoint: CGPoint) -> Bool {
			let qX = Double(erasePoint.x), qY = Double(erasePoint.y)
			let pX = line.x1 + (line.x2 * ((qX - line.x1) * (line.x2 - line.x1) / line.mag))
			let pY = line.y1 + (line.y2 * ((qY - line.y1) * (line.y2 - line.y1) / line.mag))
			let altitude = Vector(qX, qY, pX, pY)
			let qA = Vector(qX, qY, line.x2, line.y2)
			let qB = Vector(qX, qY, line.x1, line.y1)
			
			if (altitude.mag > qA.mag) {
				return qA.mag < 25
			}
			else if (altitude.mag > qB.mag) {
				return qB.mag < 25
			}
			
			return altitude.mag < 25
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
		var i = 0
		for line in drawnLines {
			aCoder.encodeObject(line, forKey: "line" + String(i))
			i += 1
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
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
