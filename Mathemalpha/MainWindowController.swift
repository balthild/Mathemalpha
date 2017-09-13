//
//  MainWindowController.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true
    }

    func showAndOrderFront(_ sender: Any?) {
        showWindow(sender)

        window?.orderFrontRegardless()
        window?.makeKeyAndOrderFront(sender)
    }

}
