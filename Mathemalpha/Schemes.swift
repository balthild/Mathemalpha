//
//  Schemes.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 20/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

final class Schemes {

    static let baseDir = NSHomeDirectory() + "/Library/Application Support/Mathemalpha"

    private(set) static var schemeNames: Array<String> = []
    private(set) static var schemes: Array<Array<String>> = []

    static func load() {
        do {
            try FileManager.default.createDirectory(atPath: baseDir, withIntermediateDirectories: true)
        } catch {
            debugPrint(error)
            NSApp.terminate(self)
        }

        var isDir: ObjCBool = false

        if (!FileManager.default.fileExists(atPath: baseDir + "/schemes.txt", isDirectory: &isDir)) {
            createDefaultSchemes()
        }

        readSchemes()
    }

    private static func readSchemes() {
        var newSchemeNames: Array<String> = []
        var newSchemes: Array<Array<String>> = []

        var msg = ""

        do {
            let schemesConfig = try String(contentsOfFile: baseDir + "/schemes.txt")

            var i = 0
            for (num, line) in schemesConfig.components(separatedBy: "\n").enumerated() {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)

                if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
                    continue
                }

                let pair = trimmedLine.components(separatedBy: ":")

                if pair.count != 2 {
                    throw ParseError(num)
                }

                let name = pair[0].trimmingCharacters(in: .whitespaces)
                let file = pair[1].trimmingCharacters(in: .whitespaces)

                if name.isEmpty || file.isEmpty {
                    throw ParseError(num)
                }

                do {
                    let scheme = try String(contentsOfFile: baseDir + "/schemes/" + file)

                    newSchemes.append(scheme.components(separatedBy: "\n").map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ !$0.isEmpty }))
                    newSchemeNames.append(name)
                } catch {
                    NSLog("Error while loading " + file)
                    continue
                }
            }

            msg = "No Schemes"
        } catch let e as ParseError {
            NSLog(e.message)
            msg = "Parse Error"
        } catch {
            debugPrint(error)
            msg = "Unknown Error"
        }

        if newSchemes.isEmpty {
            newSchemeNames.append(msg)
            newSchemes.append(["π"])
        }

        schemes = newSchemes
        schemeNames = newSchemeNames
    }

    private static func createDefaultSchemes() {
        do {
            try FileManager.default.createDirectory(atPath: baseDir + "/schemes", withIntermediateDirectories: true)

            let schemesConfig = NSDataAsset(name: "schemes.txt")!
            try schemesConfig.data.write(to: URL(fileURLWithPath: baseDir + "/schemes.txt"))

            for name in ["math.txt", "hellenic.txt", "cyrillic.txt", "latin.txt"] {
                let schemeFile = NSDataAsset(name: name)!
                try schemeFile.data.write(to: URL(fileURLWithPath: baseDir + "/schemes/" + name))
            }
        } catch {
            debugPrint(error)
        }
    }
}

class ParseError: Error {
    let line: Int!

    var message: String {
        get {
            return "Error while parsing schemes.txt at line " + String(line)
        }
    }

    init(_ line: Int) {
        self.line = line
    }
}
