import "./fmt" for Fmt

var a = List.filled(17, null)
for (i in 0..16) a[i] = List.filled(17, 0)

var idx = List.filled(4, 0)

var findGroup // recursive
findGroup = Fn.new { |ctype, min, max, depth|
    if (depth == 4) {
        var cs = (ctype == 0) ? "un" : ""
        System.write("Totally %(cs)connected group:")
        for (i in 0..3) System.write(" %(idx[i])")
        System.print()
        return true
    }

    var i = min
    while (i < max) {
        var n = 0
        while (n < depth) {
            if (a[idx[n]][i] != ctype) break
            n = n + 1
        }
        if (n == depth) {
            idx[n] = i
            if (findGroup.call(ctype, 1, max, depth+1)) return true
        }
        i = i + 1
    }
    return false
}

var mark = "01-"
for (i in 0..16) a[i][i] = 2
var k = 1
while (k <= 8) {
    for (i in 0..16) {
        var j = (i + k) % 17
        a[i][j] = 1
        a[j][i] = 1
    }
    k = k << 1
}
for (i in 0..16) {
    for (j in 0..16) Fmt.write("$s ", mark[a[i][j]])
    System.print()
}

// Test case breakage
// a[2][1] = a[1][2] = 0

// It's symmetric, so only need to test groups containing node 0.
for (i in 0..16) {
    idx[0] = i
    if (findGroup.call(1, i+1, 17, 1) || findGroup.call(0, i+1, 17, 1)) {
        System.print("No good.")
        return
    }
}
System.print("All good.")
