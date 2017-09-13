//
//  KeyEvent.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class KeyEvent: NSObject {

    var appDelegate: AppDelegate!

    static let showWindowKey: UInt16 = 48
    static let showWindowModifier: NSEventModifierFlags = [.shift]

    init(appDelegate: AppDelegate) {
        super.init()

        self.appDelegate = appDelegate

        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyDown, handler: {(e: NSEvent) -> Void in
            switch (e.keyCode, e.modifierFlags.intersection(.deviceIndependentFlagsMask)) {
            case (KeyEvent.showWindowKey, KeyEvent.showWindowModifier):
                // Shift + Tab
                self.appDelegate.mainWindowController.showAndOrderFront(self)

            default:
                // debugPrint(e)
                break
            }
        })

        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown, handler: {(e: NSEvent) -> NSEvent? in
            switch (e.keyCode, e.modifierFlags.intersection(.deviceIndependentFlagsMask)) {
            case (53, _), (13, [.command]):
                // Esc, Cmd + W
                self.appDelegate.mainWindowController.close()

            default:
                // debugPrint(e)
                break
            }

            return nil
        })

        // NSLog("Add local keyboard event listener")
    }

}
