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
		if let touch = touches.first {
			let end = touch.locationInView(self)
			if let start = self.start {
				switch master.currentDrawTool {
					case .PEN:
						drawFromPoint(start, toPoint: end, color: UIColor.blackColor(), size: 5)
						break
					case .ERASER:
						drawFromPoint(start, toPoint: end, color: self.backgroundColor!, size: 30)
						break
					case .SCISSORS:
						break
					case .TEXTBOX:
						break
				}
			}
			self.start = end
		}
	}
	
	func drawFromPoint(start: CGPoint, toPoint end: CGPoint, color: UIColor, size: Int) {
		// set the context to that of an image
		UIGraphicsBeginImageContext(self.frame.size)
		let context = UIGraphicsGetCurrentContext()
		// draw the existing image onto the current context
		image?.drawInRect(CGRect(x: 0, y: 0,
			width: (image?.size.width)!, height: (image?.size.height)!))
		// draw the new line segment
		CGContextSetLineWidth(context, CGFloat(size))
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		CGContextBeginPath(context)
		CGContextMoveToPoint(context, start.x, start.y)
		CGContextAddLineToPoint(context, end.x, end.y)
		CGContextStrokePath(context)
		// obtain a UIImage object from the context
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		// set the UIImageView's image to the new, generated image
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