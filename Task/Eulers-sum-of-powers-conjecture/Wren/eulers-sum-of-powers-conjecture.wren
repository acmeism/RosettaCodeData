var start = System.clock
var n = 250
var m = 30

var p5 = List.filled(n+m+1, 0)
var s = 0
while (s < n) {
    var sq = s * s
    p5[s] = sq * sq * s
    s = s + 1
}
var max = p5[n-1]
while (s < p5.count) {
    p5[s] = max + 1
    s = s + 1
}
for (a in 1...n-3) {
    for (b in a + 1...n-2) {
        for (c in b + 1...n-1) {
            var d = c + 1
            var t = p5[a] + p5[b] + p5[c]
            var e = d + (t % m)
            s = t + p5[d]
            while (s <= max) {
                e = e - m
                while (p5[e+m] <= s) e = e + m
                if (p5[e] == s) {
                    System.print("%(a)⁵ + %(b)⁵ + %(c)⁵ + %(d)⁵ = %(e)⁵")
                    System.print("Took %(System.clock - start) seconds")
                    return
                }
                d = d + 1
                e = e + 1
                s = t + p5[d]
            }
        }
    }
}
