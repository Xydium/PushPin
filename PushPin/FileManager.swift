//
//  FileManager.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/28/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation
import UIKit

class FileManager {
	
	var pushpinFiles = [PushpinFile]()
	
	func newFile(name: String) {
		pushpinFiles.append(PushpinFile(fileName: name, lastModified: NSDate()))
	}
	
}