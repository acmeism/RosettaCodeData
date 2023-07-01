import Foundation

let hello = "Hello, World!"
let fromC = strdup(hello)
let backToSwiftString = String.fromCString(fromC)
