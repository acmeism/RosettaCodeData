import Foundation

let path = "~/input.txt".stringByExpandingTildeInPath
if let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
  println(string) // print contents of file
}
