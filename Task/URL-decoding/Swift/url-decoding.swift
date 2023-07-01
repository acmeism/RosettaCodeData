import Foundation

let encoded = "http%3A%2F%2Ffoo%20bar%2F"
if let normal = encoded.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
  println(normal)
}
