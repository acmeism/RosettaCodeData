var kolakoski = Fn.new { |c, slen|
    var s = List.filled(slen, 0)
    var i = 0
    var k = 0
    while (true) {
        s[i] = c[k % c.count]
        if (s[k] > 1) {
            for (j in 1...s[k]) {
                i = i + 1
                if (i == slen) return s
                s[i] = s[i-1]
            }
        }
        i = i + 1
        if (i == slen) return s
        k = k + 1
    }
}

var possibleKolakoski = Fn.new { |s|
    var slen = s.count
    var rle = []
    var prev = s[0]
    var count = 1
    for (i in 1...slen) {
        if (s[i] == prev) {
            count = count + 1
        } else {
            rle.add(count)
            count = 1
            prev = s[i]
        }
    }
    // no point adding final 'count' to rle as we're not going to compare it anyway
    for (i in 0...rle.count) {
        if (rle[i] != s[i]) return false
    }
    return true
}

var ias = [
    [1, 2],
    [2, 1],
    [1, 3, 1, 2],
    [1 ,3, 2, 1]
]
var slens = [20, 20, 30, 30]
var i = 0
for (ia in ias) {
    var slen = slens[i]
    var kol = kolakoski.call(ia, slen)
    System.write("First %(slen) members of the sequence generated by ")
    System.print("%(ia):")
    System.print("%(kol)")
    var p = possibleKolakoski.call(kol)
    var poss = p ? "Yes" : "No"
    System.print("Possible Kolakoski sequence? %(poss)\n")
    i = i + 1
}
