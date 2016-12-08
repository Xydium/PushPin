//
//  Pin.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import CoreGraphics

class Pin {
    
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
	
}