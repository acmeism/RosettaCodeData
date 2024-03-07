import "io" for File
import "./str" for Str
import "./sort" for Sort
import "./fmt" for Fmt
import "./pattern" for Pattern

var fileName = "135-0.txt"
var text = File.read(fileName).trimEnd()
var groups = {}
// match runs of A-z, a-z, 0-9 and any non-ASCII letters with code-points < 256
var p = Pattern.new("+1&w")
var lines = text.split("\n")
for (line in lines) {
    var ms = p.findAll(line)
    for (m in ms) {
        var t = Str.lower(m.text)
        groups[t] = groups.containsKey(t) ? groups[t] + 1 : 1
    }
}
var keyVals = groups.toList
Sort.quick(keyVals, 0, keyVals.count - 1) { |i, j| (j.value - i.value).sign }
System.print("Rank  Word  Frequency")
System.print("====  ====  =========")
for (rank in 1..10) {
    var word = keyVals[rank-1].key
    var freq = keyVals[rank-1].value
    Fmt.print("$2d    $-4s    $5d", rank, word, freq)
}
