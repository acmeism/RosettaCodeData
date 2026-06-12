import "io" for File
import "./fmt" for Fmt

var hasAIOU = Fn.new { |word| word.any { |c| "aiou".contains(c) } }
var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count >= 4 && !hasAIOU.call(w) }.toList
var count = 0
for (word in words) {
    if (word.count { |c| c == "e" } > 3) {
        count = count + 1
        Fmt.print("$2d: $s", count, word)
    }
}
