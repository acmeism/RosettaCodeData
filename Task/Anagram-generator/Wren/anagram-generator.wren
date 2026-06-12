import "io" for File
import "./str" for Str, Char
import "./perm" for Comb
import "./seq" for Lst
import "./sort" for Sort

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).split("\n").map { |w| w.trim() }
var wordMap = {}
for (word in words) {
    var letters = word.toList
    Sort.insertion(letters)
    var sortedWord = letters.join()
    if (wordMap.containsKey(sortedWord)) {
        wordMap[sortedWord].add(word)
    } else {
        wordMap[sortedWord] = [word]
    }
}

var anagramGenerator = Fn.new { |text|
    var letters = Str.lower(text).toList
    // remove any non-letters
    for (i in letters.count-1..0) {
        if (!Char.isLetter(letters[i])) letters.removeAt(i)
    }
    var lc = letters.count
    if (lc < 2) return
    var h = (lc/2).floor
    var tried = {}
    for (n in h..1) {
        var sameLength = (lc == 2 * n)
        for (letters1 in Comb.list(letters, n)) {
            Sort.insertion(letters1)
            letters1 = letters1.join()
            if (tried[letters1]) continue
            tried[letters1] = true
            var anagrams = wordMap[letters1]
            if (anagrams) {
                var letters2 = Lst.except(letters, letters1.toList)
                Sort.insertion(letters2)
                letters2 = letters2.join()
                if (sameLength) {
                    if (tried[letters2]) continue
                    tried[letters2] = true
                }
                var anagrams2 = wordMap[letters2]
                if (anagrams2) {
                    for (word1 in anagrams) {
                        for (word2 in anagrams2) {
                            System.print("  " + word1 + " " + word2)
                        }
                    }
                }
            }
        }
    }
}

var tests = ["Rosettacode", "PureFox", "Petelomax", "Wherrera", "Thundergnat", "ClintEastwood"]
for (i in 0...tests.count) {
    System.print("\n%(tests[i]):")
    anagramGenerator.call(tests[i])
}
