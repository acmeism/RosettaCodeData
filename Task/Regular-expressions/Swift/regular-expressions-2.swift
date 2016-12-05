import Foundation

let orig = "I am the original string"
let result = orig.stringByReplacingOccurrencesOfString("original", withString: "modified", options: .RegularExpressionSearch)
println(result)
