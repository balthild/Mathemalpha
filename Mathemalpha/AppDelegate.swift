//
//  AppDelegate.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var keyEvent: KeyEvent!
    var mainWindowController: MainWindowController!

    override init() {
        super.init()

        mainWindowController = MainWindowController(windowNibName: "MainWindow")
        keyEvent = KeyEvent(appDelegate: self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}