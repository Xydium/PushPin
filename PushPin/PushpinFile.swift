//
//  PushpinFile.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation

class PushpinFile {

	let fileName: String
	let lastModified: NSDate
	let pinManager: PinManager
	
	init(fileName: String, lastModified: NSDate) {
		self.fileName = fileName
		self.lastModified = lastModified
		self.pinManager = PinManager()
	}
	
}
