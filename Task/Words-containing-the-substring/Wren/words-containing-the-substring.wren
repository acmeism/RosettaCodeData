import "io" for File
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count > 11 }.toList
var count = 0
System.print("Words containing 'the' having a length > 11 in %(wordList):")
for (word in words) {
    if (word.contains("the")) {
        count = count + 1
        Fmt.print("$2d: $s", count, word)
    }
}
