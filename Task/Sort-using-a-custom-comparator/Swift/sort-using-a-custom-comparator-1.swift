import Foundation

var list = ["this",
  "is",
  "a",
  "set",
  "of",
  "strings",
  "to",
  "sort",
  "This",
  "Is",
  "A",
  "Set",
  "Of",
  "Strings",
  "To",
  "Sort"]

list.sortInPlace {lhs, rhs in
  let lhsCount = lhs.characters.count
  let rhsCount = rhs.characters.count
  let result = rhsCount - lhsCount

  if result == 0 {
    return lhs.lowercaseString > rhs.lowercaseString
  }

  return lhsCount > rhsCount
}
