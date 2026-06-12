import "./ioutil" for FileUtil
import "./str" for Str

var abcIncrementalCounts = Fn.new { |fileName, letters, minCount|
    var res = []
    var words = FileUtil.readLines(fileName) // local copy
    for (word in words) {
        word = Str.lower(word)
        var c1 = Str.occurs(word, letters[0])
        if (c1 < minCount) continue
        var c2 = Str.occurs(word, letters[1])
        if (c2 < minCount) continue
        var c3 = Str.occurs(word, letters[2])
        if (c3 < minCount) continue
        var l = [c1, c2, c3].sort()
        if (l[1] != l[0] + 1 || l[2] != l[1] + 1) continue
        res.add(word)
    }
    return res
}

var fileNames = ["unixdict.txt", "words_alpha.txt"]
var letters = [["a", "b", "c"], ["t", "h", "e"], ["c", "i", "o"]]
var minCounts = [[1, 1, 2], [2, 2, 3]]
for (i in 0...fileNames.count) {
    System.print("Using %(fileNames[i]):\n")
    for (j in 0...letters.count) {
        System.print("Letters: %(letters[j]) -- Minimum count %(minCounts[i][j])")
        var res = abcIncrementalCounts.call(fileNames[i], letters[j], minCounts[i][j])
        if (res.count > 0) {
            System.print(res.join("\n"))
        } else {
            System.print("<none>")
        }
        System.print()
    }
    System.print()
}
