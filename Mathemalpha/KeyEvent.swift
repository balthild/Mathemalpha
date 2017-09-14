//
//  KeyEvent.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox.Events
import Magnet
import KeyHolder

class KeyEvent: NSObject {

    static let defaultKeyCode: Int = kVK_Space
    static let defaultModifiers: NSEventModifierFlags = [.option, .command]

    let appDelegate: AppDelegate = NSApp.delegate as! AppDelegate

    var keyCombo: KeyCombo!
    var hotKey: HotKey!

    override init() {
        super.init()

        keyCombo = KeyCombo(keyCode: KeyEvent.defaultKeyCode, cocoaModifiers: KeyEvent.defaultModifiers)
        hotKey = HotKey(identifier: "ShowWindow", keyCombo: keyCombo, target: appDelegate, action: #selector(MainWindowController.showAndOrderFront))
        hotKey.register()

        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown, handler: {(e: NSEvent) -> NSEvent? in
            switch (e.keyCode, e.modifierFlags.intersection(.deviceIndependentFlagsMask)) {
            case (53, _), (13, [.command]):
                // Esc, Cmd + W
                self.appDelegate.mainWindowController.close()

            default:
#if DEBUG
                    debugPrint(e)
#endif

                break
            }

            return e
        })

#if DEBUG
            NSLog("Added local keyboard event listener")
#endif
    }

}

extension KeyEvent: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        // You can customize validation
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
#if DEBUG
        NSLog("Clear shortcut")
#endif

        HotKeyCenter.shared.unregisterHotKey(with: "ShowWindow")
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
#if DEBUG
        NSLog("End recording")
#endif
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
#if DEBUG
        NSLog("Recorded")
#endif

        HotKeyCenter.shared.unregisterHotKey(with: "ShowWindow")
        let hotKey = HotKey(identifier: "ShowWindow", keyCombo: keyCombo, target: appDelegate.mainWindowController, action: #selector(MainWindowController.showAndOrderFront))
        hotKey.register()
    }
}
