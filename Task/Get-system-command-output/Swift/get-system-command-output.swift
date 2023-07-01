import Foundation

let process = Process()

process.launchPath = "/usr/bin/env"
process.arguments = ["pwd"]

let pipe = Pipe()
process.standardOutput = pipe

process.launch()

let data = pipe.fileHandleForReading.readDataToEndOfFile()
let output = String.init(data: data, encoding: String.Encoding.utf8)

print(output!)
