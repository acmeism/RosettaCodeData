import "./str" for Str

var duval = Fn.new { |s|
    var n = s.count
    var i = 0
    var factorization = []
    while (i < n) {
        var j = i + 1
        var k = i
        while (j < n && Str.le(s[k], s[j])) {
            if (Str.lt(s[k], s[j])) k = i else k = k + 1
            j = j + 1
        }
        while (i <= k) {
            factorization.add(s[i...i+j-k])
            i = i + j - k
        }
    }
    return factorization
}

// Thue-Morse example
var m = "0"
for (i in 0..6) {
    var m0 = m
    m = m.replace("0", "a")
    m = m.replace("1", "0")
    m = m.replace("a", "1")
    m = m0 + m
}
System.print(duval.call(m).join("\n"))
