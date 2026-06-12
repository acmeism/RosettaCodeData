import "io" for File
import "./sort" for Find
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count >= 9 }.toList
var count = 0
var alreadyFound = []
for (i in 0...words.count - 9) {
    var word = ""
    for (j in i...i+9) word = word + words[j][j-i]
    if (Find.all(words, word)[0] && !Find.all(alreadyFound, word)[0]) {
        count = count + 1
        Fmt.print("$2d: $s", count, word)
        alreadyFound.add(word)
    }
}
