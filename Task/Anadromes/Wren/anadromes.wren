import "io" for File
import "./sort" for Sort, Find
import "./fmt" for Fmt

var wordList = "words.txt" // local copy
var words = File.read(wordList)
                .trimEnd()
                .split("\n")
                .where { |word| word.count > 6 }
                .toList

Sort.quick(words) // need strict lexicographical order to use binary search
var anadromes = []
for (word in words) {
    var word2 = word[-1..0]
    if (word != word2 && !anadromes.contains(word2) && Find.first(words, word2) >= 0) {
        anadromes.add(word)
    }
}
System.print("The anadrome pairs with more than 6 letters are:")
for (ana in anadromes) Fmt.print("$8s <-> $8s", ana, ana[-1..0])
