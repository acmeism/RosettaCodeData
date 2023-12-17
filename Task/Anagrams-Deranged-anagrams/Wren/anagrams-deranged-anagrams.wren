import "io" for File
import "./sort" for Sort

// assumes w1 and w2 are anagrams of each other
var isDeranged = Fn.new { |w1, w2|
    for (i in 0...w1.count) {
        if (w1[i] == w2[i]) return false
    }
    return true
}

var words = File.read("unixdict.txt").split("\n").map { |w| w.trim() }
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

var deranged = []
for (key in wordMap.keys) {
    var ana = wordMap[key]
    var count = ana.count
    if (count > 1) {
        for (i in 0...count-1) {
            for (j in i + 1...count) {
                if (isDeranged.call(ana[i], ana[j])) deranged.add([ana[i], ana[j]])
            }
        }
    }
}

var most = deranged.reduce(0) { |max, words| (words[0].count > max) ? words[0].count : max }
for (words in deranged) {
    if (words[0].count == most) System.print([words[0], words[1]])
}
