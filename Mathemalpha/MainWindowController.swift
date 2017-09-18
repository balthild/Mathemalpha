//
//  MainWindowController.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var charactersScrollView: NSScrollView!
    @IBOutlet weak var charactersView: CharactersView!

    var shouldHandleKeyEvent: Bool = false
    var charactersAreaHeight: CGFloat!

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true

        // See KeyEvent.keyPressed @ case (49, []) in KeyEvent.swift
        window?.animationBehavior = .none

        charactersAreaHeight = charactersScrollView.frame.size.height
    }

    func hide(_ sender: Any?) {
        window?.orderOut(sender)

        shouldHandleKeyEvent = false
    }

    func showAndOrderFront(_ sender: Any?) {
        showWindow(sender)

        window?.orderFrontRegardless()
        window?.makeKeyAndOrderFront(sender)

        shouldHandleKeyEvent = true
    }

    func changeHighlightCharacter(_ keyCode: UInt16) {
        let sections = charactersView.sections
        let lastSection = sections.count - 1
        var (section, index) = charactersView.highlight

        switch keyCode {
        case 123:
            // Left
            if index == 0 && section > 0 {
                // Go to previous section
                section -= 1
                index = sections[section].characters.count - 1
            } else if index > 0 {
                index -= 1
            }

        case 124:
            // Right
            if index == sections[section].characters.count - 1 && section < lastSection {
                // Go to next section
                section += 1
                index = 0
            } else if index < sections[section].characters.count - 1 {
                index += 1
            }

        case 125:
            // Down
            let remainder = sections[section].characters.count % 10
            if remainder == 0 || sections[section].characters.count - index <= remainder {
                if section < lastSection {
                    // Go to next section
                    section += 1
                    index = index % 10
                } else {
                    // Go to the end
                    index = sections[section].characters.count - 1
                }
            } else {
                // Go to next line
                index += 10
            }

            if index >= sections[section].characters.count {
                index = sections[section].characters.count - 1
            }

        case 126:
            // Up
            if index < 10 && section > 0 {
                // Go to previous section
                section -= 1
                index += sections[section].characters.count / 10 * 10

                if sections[section].characters.count % 10 == 0 {
                    index -= 10
                }

                if index >= sections[section].characters.count {
                    index = sections[section].characters.count - 1
                }
            } else if index >= 10 {
                index -= 10
            }

        default:
            // Unreachable
            break
        }

        charactersView.highlight = (section, index)

        // Scroll to the highlighted character
        var y: Int = 0
        for i in 0..<section {
            y += (sections[i].characters.count - 1) / 10 * 32 + 40
        }
        y += index / 10 * 32

        let scrollY = charactersScrollView.contentView.documentVisibleRect.origin.y
        let floatY = CGFloat(y)

        if floatY - scrollY > charactersAreaHeight - 64 {
            charactersScrollView.documentView?.scroll(NSMakePoint(0, floatY + 64 - charactersAreaHeight))
        } else if floatY - scrollY < 32 {
            charactersScrollView.documentView?.scroll(NSMakePoint(0, floatY - 32))
        }

        reDraw()
    }

    func reDraw() {
        charactersView.needsDisplay = true
    }

    func getCurrentChar() -> Character {
        let (s, i) = charactersView.highlight
        let section = charactersView.sections[s]

        return section[section.index(section.startIndex, offsetBy: i)]
    }

}
