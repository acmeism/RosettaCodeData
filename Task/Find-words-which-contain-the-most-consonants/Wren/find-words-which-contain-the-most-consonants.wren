import "io" for File
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var vowelIndices = [0, 4, 8, 14, 20]
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count > 10 }
var wordGroups = List.filled(12, null) // should be enough
for (i in 0..11) wordGroups[i] = []

for (word in words) {
    var letters = List.filled(26, 0)
    for (c in word) {
        var index = c.bytes[0] - 97
        if (index >= 0 && index < 26) letters[index] = letters[index] + 1
    }
    var eligible = true
    var uc = 0 // number of unique consonants
    for (i in 0..25) {
        if (!vowelIndices.contains(i)) {
            if (letters[i] > 1) {
                eligible = false
                break
            } else if (letters[i] == 1) {
                uc = uc + 1
            }
        }
    }
    if (eligible) wordGroups[uc].add(word)
}

for (i in 11..0) {
    var count = wordGroups[i].count
    if (count > 0) {
        var s = (count == 1)  ? "" : "s"
        System.print("%(count) word%(s) found with %(i) unique consonants:")
        Fmt.tprint("$-14s", wordGroups[i], 5)
        System.print()
    }
}
