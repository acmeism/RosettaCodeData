var N = 2200
var N2 = N * N * 2
var s = 3
var s1 = 0
var s2 = 0
var r = List.filled(N + 1, false)
var ab = List.filled(N2 + 1, false)

for (a in 1..N) {
    var a2 = a * a
    for (b in a..N) ab[a2 + b*b] = true
}

for (c in 1..N) {
    s1 = s
    s = s + 2
    s2 = s
    var d = c + 1
    while (d <= N) {
        if (ab[s1]) r[d] = true
        s1 = s1 + s2
        s2 = s2 + 2
        d = d + 1
    }
}

for (d in 1..N) {
    if (!r[d]) System.write("%(d) ")
}
System.print()
