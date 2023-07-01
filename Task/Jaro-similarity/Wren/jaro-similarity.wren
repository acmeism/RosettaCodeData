import "/fmt" for Fmt

var jaro = Fn.new { |s1, s2|
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

System.print(Fmt.f(0, jaro.call("MARTHA", "MARHTA")))
System.print(Fmt.f(0, jaro.call("DIXON", "DICKSONX")))
System.print(Fmt.f(0, jaro.call("JELLYFISH", "SMELLYFISH")))
