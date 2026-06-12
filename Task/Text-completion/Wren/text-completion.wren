import "io" for File
import "./fmt" for Fmt

var levenshtein = Fn.new { |s, t|
    var ls = s.count
    var lt = t.count
    var d = List.filled(ls + 1, null)
    for (i in 0..ls) {
        d[i] = List.filled(lt + 1, 0)
        d[i][0] = i
    }
    for (j in 0..lt) d[0][j] = j
    for (j in 1..lt) {
        for (i in 1..ls) {
            if (s[i-1] == t[j-1]) {
                d[i][j] = d[i-1][j-1]
            } else {
                var min = d[i-1][j]
                if (d[i][j-1] < min) min = d[i][j-1]
                if (d[i-1][j-1] < min) min = d[i-1][j-1]
                d[i][j] = min + 1
            }
        }
    }
    return d[-1][-1]
}

var search = "complition"
var words = File.read("unixdict.txt").split("\n").map { |w| w.trim() }.where { |w| w != "" }
var lev = [[], [], [], []]
var ld
for (word in words) {
    if ((ld = levenshtein.call(search, word)) < 4) {
        lev[ld].add(word)
    }
}

System.print("Input word: %(search)\n")
for (i in 1..3) {
    var count = search.count
    var similarity = (count - i) * 100 / count
    Fmt.print("Words which are $4.1f\% similar:", similarity)
    System.print(lev[i])
    System.print()
}
