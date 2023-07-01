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

sort(&list) {lhs, rhs in
    let lhsCount = count(lhs)
    let rhsCount = count(rhs)
    let result = rhsCount - lhsCount

    if result == 0 {
        return lhs.lowercaseString > rhs.lowercaseString
    }

    return lhsCount > rhsCount
}
