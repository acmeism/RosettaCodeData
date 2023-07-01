import Foundation

if let regex = NSRegularExpression(pattern: "string$", options: nil, error: nil) {
  let str = "I am a string"
  if let result = regex.firstMatchInString(str, options: nil, range: NSRange(location: 0, length: count(str.utf16))) {
    println("Ends with 'string'")
  }
}
