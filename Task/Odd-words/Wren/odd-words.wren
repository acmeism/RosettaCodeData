import "io" for File
import "./fmt" for Fmt
import "./sort" for Find
import "./iterate" for Stepped

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n")
var count = 0
System.print("The odd words with length > 4 in %(wordList) are:")
for (word in words) {
    if (word.count > 8) {
        var s = ""
        var chars = word.toList // in case any non-ASCII
        for (i in Stepped.new(0...chars.count, 2)) s = s + chars[i]
        if (Find.first(words, s) >= 0) { // binary search
            count = count + 1
            Fmt.print("$2d: $-12s -> $s", count, word, s)
        }
    }
}
