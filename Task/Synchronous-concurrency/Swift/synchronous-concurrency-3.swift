//
//  main.swift
//

import Foundation

dispatch_async(dispatch_get_global_queue(0, 0)) {
    let printer = Printer()
    printer.waitForLines()
}

dispatch_async(dispatch_get_global_queue(0, 0)) {
    let reader = Reader()
    reader.readFile()
}

CFRunLoopRun()
