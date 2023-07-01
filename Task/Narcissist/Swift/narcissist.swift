#! /usr/bin/swift
import Foundation

let script = CommandLine.arguments[0]
print(script)
let mytext = try? String.init(contentsOfFile: script, encoding: .utf8)

var enteredtext = readLine()
if mytext == enteredtext {
    print("Accept")
} else {
    print("Reject")
}
