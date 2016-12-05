import Foundation

guard
    let url =  NSURL(string: "http://www.puzzlers.org/pub/wordlists/unixdict.txt"),
    let input = try? NSString(contentsOfURL: url,encoding: NSUTF8StringEncoding) as String
    else { exit(EXIT_FAILURE) }

let words = input.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
let group: ([Int: [String]], String) -> [Int: [String]] = {
    var d = $0; let g = d[$1.characters.count] ?? []
    d[$1.characters.count] = g + [$1]
    return d
}
let ordered: ([String], String) -> [String] = {
    guard String($1.characters.sort()) == $1 else { return $0 }
    return $0 + [$1]
}

let groups = words
    .reduce([String](), combine: ordered)
    .reduce([Int: [String]](), combine: group)

guard
    let maxLength = groups.keys.maxElement(),
    let maxLengthGroup = groups[maxLength]
    else { exit(EXIT_FAILURE) }

maxLengthGroup.forEach { print($0) }
