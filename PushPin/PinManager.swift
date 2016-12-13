//
//  PinManager.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit

@objc
class PinManager : NSObject, NSCoding {
    
    var pins = [Pin]()
	var filteredPins = [Pin]()
	var currentQuery = ""
	
	override init() {
		
	}
	
    func addPin(pin: Pin) {
        pins.append(pin)
    }
	
	func search(query: String) {
		currentQuery = query
		filteredPins = pins.filter({ $0.isBeingSearchedFor(currentQuery) })
	}
	
	func findPinIndex(pin: Pin) -> Int {
		for i in 0...pins.count {
			if pins[i] === pin {
				return i
			}
		}
		return -1
	}
	
	func findFilteredPinIndex(pin: Pin) -> Int {
		for i in 0...filteredPins.count {
			if filteredPins[i] === pin {
				return i
			}
		}
		return -1
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeInt(Int32(pins.count), forKey: "numPins")
		var i = 0
		for pin in pins {
			aCoder.encodeObject(pin, forKey: "pin" + String(i))
			i += 1
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		var i = 0
		while i < Int(aDecoder.decodeIntForKey("numPins")) {
			pins.append(aDecoder.decodeObjectForKey("pin" + String(i)) as! Pin)
			i += 1
		}
	}
	
}
