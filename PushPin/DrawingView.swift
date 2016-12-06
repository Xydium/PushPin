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
		if let touch = touches.first {
			start = touch.locationInView(self)
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if master.currentFile == nil {
			return
		}
		if let touch = touches.first {
			if master.currentDrawTool == DrawTools.SCISSORS {
				master.currentFile.removeInZone(start!, touch.locationInView(self))
				print("ran")
				redraw()
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
						break
					case .TEXTBOX:
						break
				}
			}
		}
	}
	
	func redraw() {
		if master.currentFile == nil {
			return
		}
		
		UIGraphicsBeginImageContext(self.frame.size)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetLineWidth(context, CGFloat(5))
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		
		for line in master.currentFile.drawnLines {
			CGContextBeginPath(context)
			CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
			CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
			CGContextStrokePath(context)
		}
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		image = newImage
	}
	
}

enum DrawTools : Int {
	case PEN, ERASER, TEXTBOX, SCISSORS
	
	static func forName(name: String) -> DrawTools {
		switch name.uppercaseString {
		case "PEN":
			return DrawTools.PEN
		case "ERASER":
			return DrawTools.ERASER
		case "TEXTBOX":
			return DrawTools.TEXTBOX
		case "SCISSORS":
			return DrawTools.SCISSORS
		default:
			return DrawTools.PEN
		}
	}
}