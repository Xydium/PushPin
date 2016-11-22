//
//  PushpinFile.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation
import UIKit

class PushpinFile {

	let fileName: String
	let lastModified: NSDate
	let pinManager: PinManager
	var drawnLines: [(start: CGPoint, end: CGPoint)]
	
	init(fileName: String, lastModified: NSDate) {
		self.fileName = fileName
		self.lastModified = lastModified
		self.pinManager = PinManager()
		self.drawnLines = [(start: CGPoint, end: CGPoint)]()
	}
	
	func addDrawnLine(start: CGPoint, _ end: CGPoint) {
		drawnLines.append((start: start, end: end))
	}

	func removeIntersectingLines(start: CGPoint, _ end: CGPoint) {
		let intsct = (start: start, end: end)
		var trues = [Int]()
		if drawnLines.isEmpty {return}
		for l in 0...drawnLines.count-1 {
			if intersecting(drawnLines[l], intsct) {
				trues.append(l)
			}
		}
		for i in trues {
			drawnLines.removeAtIndex(i)
		}
	}

	func intersecting(f: (start: CGPoint, end: CGPoint), _ g:(start: CGPoint, end: CGPoint)) -> Bool {
		var det = 0.0, gamma = 0.0, lambda = 0.0
		let a = Double(f.start.x), b = Double(f.start.y), c = Double(f.end.x), d = Double(f.end.y), p = Double(g.start.x), q = Double(g.start.y), r = Double(g.end.x), s = Double(g.end.y)
		det = ((c - a) * (s - q)) - ((r - p) * (d - b))
		if det == 0 {
			return false
		} else {
			lambda = ((s - q) * (r - a) + (p - r) * (s - b)) / det
			gamma = ((b - d) * (r - a) + (c - a) * (s - b)) / det
			return (0 < lambda && lambda < 1) && (0 < gamma && gamma < 1)
		}
	}
	
}
