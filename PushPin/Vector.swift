//
//  Vector.swift
//  PushPin
//
//  Created by Timothy Hornick on 11/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit
import Foundation

struct Vector {
	
	let x1, y1, x2, y2: Double
	
	init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
		self.x1 = x1
		self.y1 = y1
		self.x2 = x2
		self.y2 = y2
	}
	
	init(_ s: CGPoint, _ e: CGPoint) {
		self.init(Double(s.x), Double(s.y), Double(e.x), Double(e.y))
	}
	
	var xcomp: Double {
		return x2 - x1
	}
	
	var ycomp: Double {
		return y2 - y1
	}
	
	var mag: Double {
		return sqrt(xcomp * xcomp + ycomp * ycomp)
	}
	
	var angle: Double {
		return sinh(ycomp / mag)
	}
	
	func dot(v: Vector) -> Double {
		return self.mag * v.mag * cos(self.angle - v.angle)
	}
	
}

func + (left: Vector, right: Vector) -> Vector {
	return Vector(left.x1, left.x2 + right.xcomp, left.y1, left.y2 + right.ycomp)
}

func - (left: Vector, right: Vector) -> Vector {
	return Vector(left.x1, left.x2 - right.xcomp, left.y1, left.y2 - right.ycomp)
}