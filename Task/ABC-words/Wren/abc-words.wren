import "io" for File
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n")
var count = 0
System.print("Based on first occurrences only, the ABC words in %(wordList) are:")
for (word in words) {
    var a = word.indexOf("a")
    var b = word.indexOf("b")
    var c = word.indexOf("c")
    if (a >= 0 && b > a && c > b) {
        count = count + 1
        Fmt.print("$2d: $s", count, word)
    }
}
