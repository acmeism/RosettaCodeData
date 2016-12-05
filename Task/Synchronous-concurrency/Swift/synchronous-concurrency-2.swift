//
//  Printer.swift
//

import Foundation

class Printer: NSObject {
    var numberOfLines = 0
    var gotRequestLineNumber = false

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotLine:",
            name: "Line", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lineNumberRequest:",
            name: "LineNumberRequest", object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func gotLine(not:NSNotification) {
        println(not.object!)
        self.numberOfLines++
    }

    func lineNumberRequest(not:NSNotification) {
        self.gotRequestLineNumber = true
        NSNotificationCenter.defaultCenter().postNotificationName("LinesPrinted", object: self.numberOfLines)
    }

    func waitForLines() {
        while !self.gotRequestLineNumber {
            sleep(1 as UInt32)
        }
    }
}
