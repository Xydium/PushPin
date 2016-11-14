//
//  PinManager.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation
import UIKit

class PinManager {
    
    var pins = [Pin]()
	var filteredPins = [Pin]()
	var currentQuery = ""
	
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
	
}
