//
//  PinManagerController.swift
//  PushPin
//
//  Created by Timothy Hornick on 11/10/16.
//  Copyright © 2016 Xydium. All rights reserved.
//

import UIKit

class PinManagerController: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	let master: ViewController
	var pinManager: PinManager { return master.currentFile.pinManager }
	init(_ master: ViewController) { self.master = master }
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PinManagerCell", forIndexPath: indexPath)
		let pin: Pin
		if pinManager.currentQuery != "" {
			pin = pinManager.filteredPins[indexPath.row]
		} else {
			pin = pinManager.pins[indexPath.row]
		}
		cell.textLabel?.text = pin.name
		cell.detailTextLabel?.text = pin.attributes
		return cell
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if pinManager.currentQuery != "" {
			pinManager.pins.removeAtIndex(pinManager.findPinIndex(pinManager.filteredPins[indexPath.row]))
			pinManager.filteredPins.removeAtIndex(indexPath.row)
		} else {
			pinManager.pins.removeAtIndex(indexPath.row)
		}
		master.pinmanagerTableView.reloadData()
		master.drawingView.redraw()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		master.drawingView.redraw()
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		master.drawingView.redraw()
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
		let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in self.tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)})
		delete.backgroundColor = UIColor(red: 0x8E / 0xFF, green: 0x85 / 0xFF, blue: 1, alpha: 1)
		
		return [delete]
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if master.currentFile == nil {
			return 0
		}
		if pinManager.currentQuery != "" {
			return pinManager.filteredPins.count
		}
		return pinManager.pins.count
	}
	
}