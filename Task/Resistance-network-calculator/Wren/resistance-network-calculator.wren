import "./fmt" for Fmt

var argmax = Fn.new { |m, i|
    var lm = m.count
    var col = List.filled(lm, 0)
    var max = -1
    var maxx = -1
    for (x in 0...lm) {
        col[x] = m[x][i].abs
        if (col[x] > max ) {
            max = col[x]
            maxx = x
        }
    }
    return maxx
}

var gauss = Fn.new { |m|
    var n = m.count
    var p = m[0].count
    for (i in 0...n) {
        var k = i + argmax.call(m[i...n], i)
        var t = m[i]
        m[i] = m[k]
        m[k] = t
        t = 1 / m[i][i]
        var j = i + 1
        while (j < p) {
            m[i][j] = m[i][j] * t
            j = j + 1
        }
        j = i + 1
        while (j < n) {
            t = m[j][i]
            var l = i + 1
            while (l < p) {
                m[j][l] = m[j][l] - t*m[i][l]
                l = l + 1
            }
            j = j + 1
        }
    }
    for (i in n-1..0) {
        for (j in 0...i) {
            m[j][p-1] = m[j][p-1] - m[j][i]*m[i][p-1]
        }
    }
    var col = List.filled(n, 0)
    for (x in 0...n) col[x] = m[x][p-1]
    return col
}

var network = Fn.new { |n, k0, k1, s|
    var m = List.filled(n, null)
    for (i in 0...n) m[i] = List.filled(n+1, 0)
    for (resistor in s.split("|")) {
        var rarr = resistor.split(" ")
        var a = Num.fromString(rarr[0])
        var b = Num.fromString(rarr[1])
        var ri = Num.fromString(rarr[2])
        var r = 1/ri
        m[a][a] = m[a][a] + r
        m[b][b] = m[b][b] + r
        if (a > 0) m[a][b] = m[a][b] - r
        if (b > 0) m[b][a] = m[b][a] - r
    }
    m[k0][k0] = 1
    m[k1][n] = 1
    return gauss.call(m)[k1]
}

var fa = [
    network.call(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8"),
    network.call(9, 0, 8, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1"),
    network.call(16, 0, 15, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1"),
    network.call(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250")
]
for (f in fa) Fmt.print("$.5g", f)
