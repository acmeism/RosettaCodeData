import "io" for File
import "./fmt" for Fmt

var hammingDist = Fn.new { |s1, s2|
    s1 = s1.toList // in case there are non-ASCII characters
    s2 = s2.toList // ditto
    var count = 0
    var i = 0
    while (i < s1.count) {
        if (s1[i] != s2[i]) {
            count = count + 1
            if (count == 2) break // don't care about counts > 2
        }
        i = i + 1
    }
    return count
}

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count > 11 }.toList
var count = 0
System.print("Changeable words in %(wordList):")
for (word1 in words) {
    for (word2 in words) {
        if (word1 != word2 && word1.count == word2.count) {
            if (hammingDist.call(word1, word2) == 1) {
                count = count + 1
                Fmt.print("$2d: $-14s -> $s", count, word1, word2)
            }
        }
    }
}
