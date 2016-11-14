//
//  Pin.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation

class Pin {
    
    let name: String
    let attributes: String
    
    init(name: String, attributes: String) {
        self.name = name
        self.attributes = attributes
    }
	
	func isBeingSearchedFor(query: String) -> Bool {
		return name.lowercaseString.containsString(query.lowercaseString) || attributes.lowercaseString.containsString(query.lowercaseString)
	}
	
}