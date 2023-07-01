import "io" for File
import "./str" for Str

var isogram = Fn.new { |word|
    if (word.count == 1) return 1
    var map = {}
    word = Str.lower(word)
    for (c in word) {
        if (map.containsKey(c)) {
            map[c] = map[c] + 1
        } else {
            map[c] = 1
        }
    }
    var chars = map.keys.toList
    var n = map[chars[0]]
    var iso = chars[1..-1].all { |c| map[c] == n }
    return iso ? n : 0
}

var isoComparer = Fn.new { |i, j|
    if (i[1] != j[1]) return i[1] > j[1]
    if (i[0].count != j[0].count) return i[0].count > j[0].count
    return Str.le(i[0], j[0])
}

var heteroComparer = Fn.new { |i, j|
    if (i[0].count != j[0].count) return i[0].count > j[0].count
    return Str.le(i[0], j[0])
}

var wordList = "unixdict.txt" // local copy
var words = File.read(wordList)
                .trimEnd()
                .split("\n")
                .map { |word| [word, isogram.call(word)] }

var isograms = words.where { |t| t[1] > 1 }
                    .toList
                    .sort(isoComparer)
                    .map { |t| "  " + t[0] }
                    .toList
System.print("List of n-isograms(%(isograms.count)) where n > 1:")
System.print(isograms.join("\n"))

var heterograms = words.where { |t| t[1] == 1 && t[0].count > 10 }
                       .toList
                       .sort(heteroComparer)
                       .map { |t| "  " + t[0] }
                       .toList
System.print("\nList of heterograms(%(heterograms.count)) of length > 10:")
System.print(heterograms.join("\n"))
