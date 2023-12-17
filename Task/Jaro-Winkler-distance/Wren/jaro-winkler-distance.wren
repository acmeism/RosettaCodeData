import "io" for File
import "./fmt" for Fmt
import "./sort" for Sort

var jaroSim = Fn.new { |s1, s2|
    var le1 = s1.count
    var le2 = s2.count
    if (le1 == 0 && le2 == 0) return 1
    if (le1 == 0 || le2 == 0) return 0
    var dist = (le2 > le1) ? le2 : le1
    dist = (dist/2).floor - 1
    var matches1 = List.filled(le1, false)
    var matches2 = List.filled(le2, false)
    var matches = 0
    var transpos = 0
    for (i in 0...s1.count) {
        var start = i - dist
        if (start < 0) start = 0
        var end = i + dist + 1
        if (end > le2) end = le2
        var k = start
        while (k < end) {
            if (!(matches2[k] || s1[i] != s2[k])) {
                matches1[i] = true
                matches2[k] = true
                matches = matches + 1
                break
            }
            k = k + 1
        }
    }
    if (matches == 0) return 0
    var k = 0
    for (i in 0...s1.count) {
        if (matches1[i]) {
            while(!matches2[k]) k = k + 1
            if (s1[i] != s2[k]) transpos = transpos + 1
            k = k + 1
        }
    }
    transpos = transpos / 2
    return (matches/le1 + matches/le2 + (matches - transpos)/matches) / 3
}

var jaroWinklerDist = Fn.new { |s, t|
    var ls = s.count
    var lt = t.count
    var lmax = (ls < lt) ? ls : lt
    if (lmax > 4) lmax = 4
    var l = 0
    for (i in 0...lmax) {
        if (s[i] == t[i]) l = l + 1
    }
    var js = jaroSim.call(s, t)
    var p = 0.1
    var ws = js + l*p*(1 - js)
    return 1 - ws
}

var misspelt = ["accomodate", "definately", "goverment", "occured", "publically", "recieve", "seperate", "untill", "wich"]
var words = File.read("unixdict.txt").split("\n").map { |w| w.trim() }.where { |w| w != "" }
for (ms in misspelt) {
    var closest = []
    for (word in words) {
       var jwd = jaroWinklerDist.call(ms, word)
       if (jwd < 0.15) closest.add([word, jwd])
    }
    System.print("Misspelt word: %(ms):")
    var cmp = Fn.new { |n1, n2| (n1[1]-n2[1]).sign }
    Sort.insertion(closest, cmp)
    for (c in closest.take(6)) Fmt.print("$0.4f $s", c[1], c[0])
    System.print()
}
