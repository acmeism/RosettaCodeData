import "random" for Random
import "./fmt" for Fmt
import "./seq" for Lst

var rand = Random.new()

var toReduced = Fn.new { |m|
    var n = m.count
    var r = List.filled(n, null)
    for (i in 0...n) r[i] = m[i].toList
    for (j in 0...n-1) {
        if (r[0][j] != j) {
            for (k in j+1...n) {
                if (r[0][k] == j) {
                    for (i in 0...n) r[i].swap(j, k)
                    break
                }
            }
        }
    }
    for (i in 1...n-1) {
        if (r[i][0] != i) {
            for (k in i+1...n) {
                if (r[k][0] == i) {
                    for (j in 0...n) {
                        var t = r[i][j]
                        r[i][j] = r[k][j]
                        r[k][j] = t
                    }
                    break
                }
            }
        }
    }
    return r
}

// 'm' is assumed to be 0 based
var printMatrix = Fn.new { |m|
    var n = m.count
    for (i in 0...n) {
        for (j in 0...n) Fmt.write("$2d ", m[i][j]+1) // back to 1 based
        System.print()
    }
    System.print()
}

// converts 4 x 4 matrix to 'flat' list
var asList16 = Fn.new { |m| Lst.flatten(m) }

// converts 5 x 5 matrix to 'flat' list
var asList25 = Fn.new { |m| Lst.flatten(m) }

// 'a' is assumed to be 0 based
var printList16 = Fn.new { |a|
    for (i in 0...4) {
        for (j in 0...4) {
            var k = i*4 + j
            Fmt.write("$2d ", a[k]+1) // back to 1 based
        }
        System.print()
    }
    System.print()
}

var shuffleCube = Fn.new { |c|
    var n = c[0].count
    var proper = true
    var rx
    var ry
    var rz
    while (true) {
        rx = rand.int(n)
        ry = rand.int(n)
        rz = rand.int(n)
        if (c[rx][ry][rz] == 0) break
    }
    while (true) {
        var ox = 0
        var oy = 0
        var oz = 0
        while (ox < n) {
            if (c[ox][ry][rz] == 1) break
            ox = ox + 1
        }
        if (!proper && rand.int(2) == 0) {
            ox = ox + 1
            while (ox < n) {
                if (c[ox][ry][rz] == 1) break
                ox = ox + 1
            }
        }
        while (oy < n) {
            if (c[rx][oy][rz] == 1) break
            oy = oy + 1
        }
        if (!proper && rand.int(2) == 0) {
            oy = oy + 1
            while (oy < n) {
                if (c[rx][oy][rz] == 1) break
                oy = oy + 1
            }
        }
        while (oz < n) {
            if (c[rx][ry][oz] == 1) break
            oz = oz + 1
        }
        if (!proper && rand.int(2) == 0) {
            oz = oz + 1
            while (oz < n) {
                if (c[rx][ry][oz] == 1) break
                oz = oz + 1
            }
        }

        c[rx][ry][rz] = c[rx][ry][rz] + 1
        c[rx][oy][oz] = c[rx][oy][oz] + 1
        c[ox][ry][oz] = c[ox][ry][oz] + 1
        c[ox][oy][rz] = c[ox][oy][rz] + 1

        c[rx][ry][oz] = c[rx][ry][oz] - 1
        c[rx][oy][rz] = c[rx][oy][rz] - 1
        c[ox][ry][rz] = c[ox][ry][rz] - 1
        c[ox][oy][oz] = c[ox][oy][oz] - 1

        if (c[ox][oy][oz] < 0) {
            rx = ox
            ry = oy
            rz = oz
            proper = false
        } else {
            proper = true
            break
        }
    }
}

var toMatrix = Fn.new { |c|
    var n = c[0].count
    var m = List.filled(n, null)
    for (i in 0...n) m[i] = List.filled(n, 0)
    for (i in 0...n) {
        for (j in 0...n) {
            for (k in 0...n) {
                if (c[i][j][k] != 0) {
                    m[i][j] = k
                    break
                }
            }
        }
    }
    return m
}

// 'from' matrix is assumed to be 1 based
var makeCube = Fn.new { |from, n|
    var c = List.filled(n, null)
    for (i in 0...n) {
        c[i] = List.filled(n, null)
        for (j in 0...n) {
            c[i][j] = List.filled(n, 0)
            var k = (!from) ? (i + j) % n : from[i][j] - 1
            c[i][j][k] = 1
        }
    }
    return c
}

// part 1
System.print("PART 1: 10,000 latin Squares of order 4 in reduced form:\n")
var from = [ [1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1] ]
var freqs4 = {}
var c = makeCube.call(from, 4)
for (i in 1..10000) {
    shuffleCube.call(c)
    var m = toMatrix.call(c)
    var rm = toReduced.call(m)
    var a16 = asList16.call(rm)
    var a16s = a16.toString // can't use a list as a map key so convert it to string
    freqs4[a16s] = freqs4[a16s] ? freqs4[a16s] + 1 : 1
}
for (me in freqs4) {
    printList16.call(me.key[1..-2].split(", ").map { |n| Num.fromString(n) }.toList)
    Fmt.print("Occurs $d times\n", me.value)
}

// part 2
System.print("\nPART 2: 10,000 latin squares of order 5 in reduced form:")
from = [ [1, 2, 3, 4, 5], [2, 3, 4, 5, 1], [3, 4, 5, 1, 2],
         [4, 5, 1, 2, 3], [5, 1, 2, 3, 4] ]
var freqs5 = {}
c = makeCube.call(from, 5)
for (i in 1..10000) {
    shuffleCube.call(c)
    var m = toMatrix.call(c)
    var rm = toReduced.call(m)
    var a25 = asList25.call(rm)
    var a25s = a25.toString // can't use a list as a map key so convert it to string
    freqs5[a25s] = freqs5[a25s] ? freqs5[a25s] + 1 : 1
}
var count = 0
for (freq in freqs5.values) {
    count = count + 1
    if (count > 1) System.write(", ")
    if ((count-1) % 8 == 0) System.print()
    Fmt.write("$2d($3d)", count, freq)
}
System.print("\n")

// part 3
System.print("\nPART 3: 750 latin squares of order 42, showing the last one:\n")
var m42
c = makeCube.call(null, 42)
for (i in 1..750) {
    shuffleCube.call(c)
    if (i == 750) m42 = toMatrix.call(c)
}
printMatrix.call(m42)

// part 4
System.print("\nPART 4: 1,000 latin squares of order 256:\n")
var start = System.clock
c = makeCube.call(null, 256)
for (i in 1..1000) shuffleCube.call(c)
var elapsed = System.clock - start
Fmt.print("Generated in $s seconds", elapsed)
