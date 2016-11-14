//
//  FileManagerController.swift
//  PushPin
//
//  Created by Timothy Hornick on 11/10/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit

class FileManagerController: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	let master: ViewController
	init(_ master: ViewController) { self.master = master }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		master.currentFile = master.fileManager.pushpinFiles[indexPath.row]
		master.pinmanagerTableView.reloadData()
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FileManagerCell", forIndexPath: indexPath)
		cell.textLabel?.text = master.fileManager.pushpinFiles[indexPath.row].fileName
		let formatter = NSDateFormatter()
		formatter.dateStyle = .ShortStyle
		cell.detailTextLabel?.text = formatter.stringFromDate(master.fileManager.pushpinFiles[indexPath.row].lastModified)
		return cell
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		master.fileManager.pushpinFiles.removeAtIndex(indexPath.row)
		master.currentFile = nil
		master.pinmanagerTableView.dataSource = nil
		master.filemanagerTableView.reloadData()
		master.pinmanagerTableView.reloadData()
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in})
		delete.backgroundColor = UIColor(red: 0x8E / 0xFF, green: 0x85 / 0xFF, blue: 1, alpha: 1)
		
		return [delete]
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return master.fileManager.pushpinFiles.count
	}
	
}