//
//  AppDelegate.swift
//  Marinara
//
//  Created by Joseph Daniels on 24/08/16.
//  Copyright © 2016 Joseph Daniels. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
	let popover = NSPopover()
    var eventMonitor: EventMonitor?
    func applicationDidFinishLaunching( aNotification: NSNotification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(AppDelegate.printQuote)
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(togglePopover)
        }
        
        popover.contentViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("QuotesViewController") as! NSViewController
        
        eventMonitor = EventMonitor(mask: [NSLeftMouseDownMask, NSRightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()

    }
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func applicationWillTerminate(_ aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    func showPopover(sender: AnyObject?) {
        eventMonitor?.start()
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        eventMonitor?.stop()
        popover.performClose(sender)
    }
    
    @objc func togglePopover(sender: AnyObject?) {
    	if popover.shown {
    		closePopover(sender)
        } else {
    		showPopover(sender)
    	}
    }
}

