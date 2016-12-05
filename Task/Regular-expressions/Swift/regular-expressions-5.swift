import Foundation

let orig = "I am the original string"
if let regex = NSRegularExpression(pattern: "original", options: nil, error: nil) {
let result = regex.stringByReplacingMatchesInString(orig, options: nil, range: NSRange(location: 0, length: count(orig.utf16)), withTemplate: "modified")
  println(result)
}
