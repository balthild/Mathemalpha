//
//  MainWindowController.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var schemesView: SchemesView!
    @IBOutlet weak var schemesScrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!

    var shouldHandleKeyEvent: Bool = false
    var switchingSchemes: Bool = false
    var schemesAreaHeight: CGFloat!

    var currentScheme: Array<String> = Schemes.schemes[0]
    var selectedCharacter: (Int, Int) = (0, 0)
    var schemeBeforeFlip: Int?

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true

        // See KeyEvent.keyPressed @ case (49, []) in KeyEvent.swift
        window?.animationBehavior = .none

        schemesAreaHeight = schemesScrollView.frame.size.height

        let nib = NSNib(nibNamed: "CharacterItem", bundle: nil)
        collectionView.register(nib, forItemWithIdentifier: "CharacterItem")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .top)
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

    func flipFocused() {
        Styles.flipFocused()
        switchingSchemes = !switchingSchemes

        if switchingSchemes {
            schemeBeforeFlip = schemesView.selected
            collectionView.deselectAll(self)
        } else {
            if schemeBeforeFlip == schemesView.selected {
                collectionView.selectItems(at: [IndexPath(item: selectedCharacter.1, section: selectedCharacter.0)], scrollPosition: .top)
            } else {
                collectionView.selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .top)
            }

            schemeBeforeFlip = nil
        }

        schemesView.needsDisplay = true
        for path in collectionView.selectionIndexPaths {
            collectionView.item(at: path)?.view.needsDisplay = true
        }
    }

    func navigate(_ keyCode: UInt16) {
        if switchingSchemes {
            changeSelectedScheme(keyCode)
        }
    }

    func changeSelectedScheme(_ keyCode: UInt16) {
        let lastScheme = Schemes.schemes.count - 1
        var selected = schemesView.selected

        switch keyCode {
        case 125:
            // Down
            if selected < lastScheme {
                selected += 1
            } else {
                return
            }

        case 126:
            // Up
            if selected > 0 {
                selected -= 1
            } else {
                return
            }

        default:
            // Left or right
            return
        }

        currentScheme = Schemes.schemes[selected]

        schemesView.selected = selected
        schemesView.needsDisplay = true

        collectionView.reloadData()
        collectionView.deselectAll(self)
        collectionView.needsDisplay = true
    }

    func getCurrentChar() -> Character {
        let section = currentScheme[selectedCharacter.0]

        return section[section.index(section.startIndex, offsetBy: selectedCharacter.1)]
    }

}

extension MainWindowController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return currentScheme.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentScheme[section].characters.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let section = currentScheme[indexPath.section]
        let item = self.collectionView.makeItem(withIdentifier: "CharacterItem", for: indexPath)

        item.representedObject = section[section.index(section.startIndex, offsetBy: indexPath.item)]

        return item
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        for path in collectionView.selectionIndexPaths {
            selectedCharacter = (path.section, path.item)
            return
        }

        selectedCharacter = (0, 0)
    }

}
