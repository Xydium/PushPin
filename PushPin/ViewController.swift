//
//  ViewController.swift
//  PushPin
//
//  Created by Timothy Hornick on 10/25/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet weak var filemanagerTableView: UITableView!
    @IBOutlet weak var pinmanagerTableView: UITableView!
	@IBOutlet weak var pinmanagerSearchBar: UISearchBar!
	
	let fileManager = FileManager()
	var fileManagerController: FileManagerController!
	var pinManagerController: PinManagerController!
	var currentFile: PushpinFile!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		fileManagerController = FileManagerController(self)
		pinManagerController = PinManagerController(self)
		pinmanagerTableView.dataSource = pinManagerController
		filemanagerTableView.dataSource = fileManagerController
		filemanagerTableView.delegate = fileManagerController
		pinmanagerSearchBar.delegate = self
		runTests()
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
		let pinPrompt = UIAlertController(title: "Add Pin", message: "Enter Pin Details", preferredStyle: .Alert)
		pinPrompt.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in return}))
		pinPrompt.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
			let nameStr : String = (nameTextField?.text)!
			let attribsStrs : String = (attribsTextField?.text)!
			self.currentFile.pinManager.addPin(Pin(name: nameStr, attributes: attribsStrs))
			self.pinmanagerTableView.reloadData()
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
		}
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		return
	}
	
	func runTests() {
		for i in 0...20 {
			fileManager.newFile("Test \(i)")
			for _ in 0...10 {
				fileManager.pushpinFiles[i].pinManager.addPin(Pin(name: String(random()), attributes: String(random())))
			}
		}
		filemanagerTableView.reloadData()
	}
	
}

