import "io" for File
import "./fmt" for Fmt

var isVowel = Fn.new { |c| "aeiou".contains(c) }

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n").where { |w| w.count > 9 }
var count = 0
System.print("Words with alternate consonants and vowels in %(wordList):\n")
for (word in words) {
    var found = true
    for (i in 0...word.count) {
        var c = word[i]
        if ((i%2 == 0 && isVowel.call(c)) || (i%2 == 1 && !isVowel.call(c))) {
            found = false
            break
        }
    }
    if (!found) {
        found = true
        for (i in 0...word.count) {
            var c = word[i]
            if ((i%2 == 0 && !isVowel.call(c)) || (i%2 == 1 && isVowel.call(c))) {
                found = false
                break
            }
        }
    }
    if (found) {
        count = count + 1
        Fmt.print("$2d: $s", count, word)
    }
}
