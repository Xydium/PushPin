//
//  DrawTools.swift
//  PushPin
//
//  Created by Timothy Hornick on 11/18/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit

class DrawingView: UIImageView {
	
	var start: CGPoint?
	var end: CGPoint?
	var master: ViewController!
	
	func setMaster(controller master: ViewController) {
		self.master = master
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if master.currentFile == nil {
			return
		}
		if let touch = touches.first {
			start = touch.locationInView(self)
			if master.placingPin {
				master.currentFile.pinManager.pins.last!.location = start!
				redraw()
				master.placingPin = false
			} else {
				master.currentFile.sameTouch = true
			}
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if master.currentFile == nil {
			return
		}
		if let touch = touches.first {
			if master.currentDrawTool == DrawTools.SCISSORS {
				master.currentFile.removeInZone(start!, touch.locationInView(self))
				redraw()
			} else {
				master.currentFile.sameTouch = false
			}
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if master.currentFile == nil {
			return
		}
		if let touch = touches.first {
			end = touch.locationInView(self)
			if Vector(start!, end!).mag < 10 {return}
			if let start = self.start {
				switch master.currentDrawTool {
					case .PEN:
						master.currentFile.addDrawnLine(start, end!)
						self.start = end
						redraw()
						break
					case .ERASER:
						master.currentFile.removeIntersectingLines(end!)
						self.start = end
						redraw()
						break
					case .SCISSORS:
						redraw(true)
						break
				}
			}
		}
	}
	
	func redraw(selector: Bool = false) {
		UIGraphicsBeginImageContext(self.frame.size)
		let context = UIGraphicsGetCurrentContext()
		
		if master.currentFile != nil {
			CGContextSetLineWidth(context, CGFloat(5))
			CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
			
			for line in master.currentFile.drawnLines {
				CGContextBeginPath(context)
				CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
				CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
				CGContextStrokePath(context)
			}
			
			for pin in master.currentFile.pinManager.pins {
				if master.currentFile.pinManager.currentQuery != "" && !pin.isBeingSearchedFor(master.currentFile.pinManager.currentQuery) { continue }
				CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
				let size = CGSize(width: 10, height: 10)
				let origin = CGPoint(x: pin.location.x - size.width / 2, y: pin.location.y - size.height / 2)
				CGContextFillEllipseInRect(context, CGRect(origin: origin, size: size))
			}
			
			if selector {
				CGContextSetFillColorWithColor(context, UIColor(red:0x8E/0xFF, green:0x85/0xFF, blue:1.0, alpha: 0.25).CGColor)
				CGContextFillRect(context, CGRect(origin: start!, size: CGSize(width: end!.x - start!.x, height: end!.y - start!.y)))
			}
		}
			
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		image = newImage
	}
	
}

enum DrawTools : Int {
	case PEN, ERASER, SCISSORS
	
	static func forName(name: String) -> DrawTools {
		switch name.uppercaseString {
		case "PEN":
			return DrawTools.PEN
		case "ERASER":
			return DrawTools.ERASER
		case "SCISSORS":
			return DrawTools.SCISSORS
		default:
			return DrawTools.PEN
		}
	}
}