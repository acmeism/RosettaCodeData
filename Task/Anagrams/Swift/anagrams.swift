import Foundation

let wordsURL = NSURL(string: "http://www.puzzlers.org/pub/wordlists/unixdict.txt")!

let wordsstring = try NSString(contentsOfURL:wordsURL , encoding: NSUTF8StringEncoding)
let allwords = wordsstring.componentsSeparatedByString("\n")

let words = allwords//[0..<100] // used to limit the size while testing

extension String {
    var charactersAscending : String {
        return String(Array(characters).sort())
    }
}

var charsToWords = [String:Set<String>]()

var biggest = 0
var biggestlists = [Set<String>]()

for thisword in words {
    let chars = thisword.charactersAscending

    var knownwords = charsToWords[chars] ?? Set<String>()
    knownwords.insert(thisword)
    charsToWords[chars] = knownwords

    if knownwords.count > biggest {
        biggest = knownwords.count

        biggestlists = [knownwords]
    }
    else if knownwords.count == biggest {
        biggestlists.append(knownwords)
    }
}

print("Found \(biggestlists.count) sets of anagrams with \(biggest) members each")
for (i, thislist) in biggestlists.enumerate() {
    print("set \(i): \(thislist.sort())")
}
