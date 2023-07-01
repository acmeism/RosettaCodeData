import Foundation

let str = "I am a string"
if let range = str.rangeOfString("string$", options: .RegularExpressionSearch) {
  println("Ends with 'string'")
}
