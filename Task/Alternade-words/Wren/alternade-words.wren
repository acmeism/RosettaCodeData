import "io" for File
import "./set" for Set
import "./fmt" for Fmt

var wordList = "unixdict.txt" // local copy
var set = Set.new()
var words = File.read(wordList).trimEnd().split("\n")
for (word in words) set.add(word)
System.print("'unixdict.txt' contains the following alternades of length 6 or more:\n")
var count = 0
for (word in words) {
    if (word.count >= 6) {
        var w1 = ""
        var w2 = ""
        var i = 0
        for (c in word) {
           if (i%2 == 0) {
                w1 = w1 + c
           } else {
                w2 = w2 + c
           }
           i = i + 1
        }
        if (set.contains(w1) && set.contains(w2)) {
            count = count + 1
            Fmt.print("$2d: $-8s -> $-4s $-4s", count, word, w1, w2)
        }
    }
}
