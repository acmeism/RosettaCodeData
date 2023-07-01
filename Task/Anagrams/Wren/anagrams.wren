import "io" for File
import "/sort" for Sort

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
var most = wordMap.keys.reduce(0) { |max, key| (wordMap[key].count > max) ? wordMap[key].count : max }
for (key in wordMap.keys) {
    if (wordMap[key].count == most) System.print(wordMap[key])
}
