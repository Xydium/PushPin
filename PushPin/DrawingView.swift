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
	var master: ViewController!
	
	func setMaster(controller master: ViewController) {
		self.master = master
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			start = touch.locationInView(self)
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if master.currentFile == nil {
			return
		}
		if let touch = touches.first {
			let end = touch.locationInView(self)
			if let start = self.start {
				switch master.currentDrawTool {
					case .PEN:
						master.currentFile.addDrawnLine(start, end)
						break
					case .ERASER:
						master.currentFile.removeIntersectingLines(start, end)
						break
					case .SCISSORS:
						break
					case .TEXTBOX:
						break
				}
				redraw()
			}
			self.start = end
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
			CGContextMoveToPoint(context, line.start.x, line.start.y)
			CGContextAddLineToPoint(context, line.end.x, line.end.y)
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