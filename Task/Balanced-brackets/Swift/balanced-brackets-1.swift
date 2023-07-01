import Foundation

func isBal(str: String) -> Bool {

  var count = 0

  return !str.characters.contains { ($0 == "["  ? ++count : --count) < 0 } && count == 0

}
