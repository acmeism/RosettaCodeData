import "io" for File
import "./sort" for Find
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var count = 0
var words = File.read(wordList).trimEnd().split("\n").
    where { |w| w.count > 5 }.toList
for (word in words) {
    if (word.contains("e")) {
        var repl = word.replace("e", "i")
        if (Find.first(words, repl) >= 0) {  // binary search
            count = count + 1
            Fmt.print("$2d: $-9s -> $s", count, word, repl)
        }
    }
}
