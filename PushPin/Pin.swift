//
//  Pin.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import CoreGraphics
import Foundation

@objc
class Pin : NSObject, NSCoding {
    
    let name: String
    let attributes: String
	var location: CGPoint
    
	init(name: String, attributes: String, location: CGPoint) {
        self.name = name
        self.attributes = attributes
		self.location = location
    }
	
	func isBeingSearchedFor(query: String) -> Bool {
		return name.lowercaseString.rangeOfString(query.lowercaseString) != nil || attributes.lowercaseString.rangeOfString(query.lowercaseString) != nil
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: "name")
		aCoder.encodeObject(attributes, forKey: "attributes")
		aCoder.encodeObject(location.x, forKey: "locationx")
		aCoder.encodeObject(location.y, forKey: "locationy")
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.name = aDecoder.decodeObjectForKey("name") as! String
		self.attributes = aDecoder.decodeObjectForKey("attributes") as! String
		self.location = CGPoint(x: aDecoder.decodeObjectForKey("locationx") as! CGFloat, y: aDecoder.decodeObjectForKey("locationy") as! CGFloat)
	}
	
}