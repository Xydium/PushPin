//
//  ViewController.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/25/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet weak var filemanagerTableView: UITableView!
    @IBOutlet weak var pinmanagerTableView: UITableView!
	@IBOutlet weak var pinmanagerSearchBar: UISearchBar!
	@IBOutlet var drawingTools: [UIBarButtonItem]!
	@IBOutlet weak var drawingView: DrawingView!
	
	let fileManager = FileManager()
	var fileManagerController: FileManagerController!
	var pinManagerController: PinManagerController!
	var currentFile: PushpinFile!
	var currentDrawTool = DrawTools.PEN
	var placingPin = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		fileManagerController = FileManagerController(self)
		pinManagerController = PinManagerController(self)
		pinmanagerTableView.dataSource = pinManagerController
		pinmanagerTableView.delegate = pinManagerController
		filemanagerTableView.dataSource = fileManagerController
		filemanagerTableView.delegate = fileManagerController
		pinmanagerSearchBar.delegate = self
		drawingView.layer.borderWidth = 1
		drawingView.layer.borderColor = defaultTextColor.CGColor
		drawingView.setMaster(controller: self)
		changeDrawTool(drawingTools[currentDrawTool.rawValue])
	}

	@IBAction func addFile(sender: AnyObject) {
		var inputTextField: UITextField?
		let filenamePrompt = UIAlertController(title: "Add File", message: "Enter File Name", preferredStyle: .Alert)
		filenamePrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
			return
		}))
		filenamePrompt.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
			let entryStr : String = (inputTextField?.text)!
			self.fileManager.newFile(entryStr)
			self.filemanagerTableView.reloadData()
		}))
		filenamePrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
			textField.placeholder = "File Name"
			textField.secureTextEntry = false
			inputTextField = textField
		})
		self.presentViewController(filenamePrompt, animated: true, completion: nil)
	}
	
	@IBAction func addPin(sender: AnyObject) {
		if currentFile == nil {
			return
		}
		var nameTextField, attribsTextField: UITextField?
		let pinPrompt = UIAlertController(title: "Add Pin", message: "Enter Pin Details, Then Tap to Place", preferredStyle: .Alert)
		pinPrompt.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in return}))
		pinPrompt.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
			let nameStr : String = (nameTextField?.text)!
			let attribsStrs : String = (attribsTextField?.text)!
			self.currentFile.pinManager.addPin(Pin(name: nameStr, attributes: attribsStrs, location: CGPoint(x: -100, y: -100)))
			self.pinmanagerTableView.reloadData()
			self.placingPin = true
		}))
		pinPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
			textField.placeholder = "Name"
			textField.secureTextEntry = false
			nameTextField = textField
		})
 		pinPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
			textField.placeholder = "Attributes"
			textField.secureTextEntry = false
			attribsTextField = textField
		})
		self.presentViewController(pinPrompt, animated: true, completion: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if currentFile != nil {
			currentFile.pinManager.search(searchText)
			pinmanagerTableView.reloadData()
			drawingView.redraw()
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		return
	}
	
	let defaultTextColor = UIColor(red:0x8E/0xFF, green:0x85/0xFF, blue:1.0, alpha: 1.0)
	let selectedTextColor = UIColor(red:0x4E/0xFF, green:0xA0/0xFF, blue:0.95, alpha: 1.0)
	@IBAction func changeDrawTool(sender: UIBarButtonItem) {
		for b in drawingTools {
			b.tintColor = defaultTextColor
		}
		sender.tintColor = selectedTextColor
		currentDrawTool = DrawTools.forName(sender.title!)
	}
	
	func loadFiles() {
		let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		
		let files = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory) as [String]
		for filename in files {
			print(filename)
		}
	}
	
}

