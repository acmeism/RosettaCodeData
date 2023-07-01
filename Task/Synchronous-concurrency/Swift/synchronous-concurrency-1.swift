//
//  Reader.swift
//

import Foundation

class Reader: NSObject {
    let inputPath = "~/Desktop/input.txt".stringByExpandingTildeInPath
    var gotNumberOfLines = false

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "linesPrinted:",
            name: "LinesPrinted", object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // Selector for the number of lines printed
    func linesPrinted(not:NSNotification) {
        println(not.object!)
        self.gotNumberOfLines = true
        exit(0)
    }

    func readFile() {
        var err:NSError?
        let fileString = NSString(contentsOfFile: self.inputPath,
            encoding: NSUTF8StringEncoding, error: &err)

        if let lines = fileString?.componentsSeparatedByString("\n") {
            for line in lines {
                NSNotificationCenter.defaultCenter().postNotificationName("Line", object: line)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LineNumberRequest", object: nil)

            while !self.gotNumberOfLines {
                sleep(1 as UInt32)
            }
        }
    }
}
