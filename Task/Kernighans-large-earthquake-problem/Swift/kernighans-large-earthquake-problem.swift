import Foundation

guard let path = Array(CommandLine.arguments.dropFirst()).first else {
  fatalError()
}

let fileData = FileManager.default.contents(atPath: path)!
let eventData = String(data: fileData, encoding: .utf8)!

for line in eventData.components(separatedBy: "\n") {
  guard let lastSpace = line.lastIndex(of: " "), // Get index of last space
        line.index(after: lastSpace) != line.endIndex, // make sure the last space isn't the end of the line
        let magnitude = Double(String(line[line.index(after: lastSpace)])),
        magnitude > 6 else { // Finally check the magnitude
    continue
  }

  print(line)
}
