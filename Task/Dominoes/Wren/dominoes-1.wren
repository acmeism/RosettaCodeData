var tableau = [
    [0, 5, 1, 3, 2, 2, 3, 1],
    [0, 5, 5, 0, 5, 2, 4, 6],
    [4, 3, 0, 3, 6, 6, 2, 0],
    [0, 6, 2, 3, 5, 1, 2, 6],
    [1, 1, 3, 0, 0, 2, 4, 5],
    [2, 1, 4, 3, 3, 4, 6, 6],
    [6, 4, 5, 1, 5, 4, 1, 4]
]

var tableau2 = [
    [6, 4, 2, 2, 0, 6, 5, 0],
    [1, 6, 2, 3, 4, 1, 4, 3],
    [2, 1, 0, 2, 3, 5, 5, 1],
    [1, 3, 5, 0, 5, 6, 1, 0],
    [4, 2, 6, 0, 4, 0, 1, 1],
    [4, 4, 2, 0, 5, 3, 6, 3],
    [6, 6, 5, 2, 5, 3, 3, 4]
]

var dominoes = []
for (j in 0...tableau[0].count) {
    for (i in 0...tableau.count) if (i <= j) dominoes.add([i, j])
}

var containsDom = Fn.new { |l, m, n|  // assumes m <= n
    for (i in 0...l.count) {
        var d = l[i]
        if (d[0] == m && d[1] == n) return true
    }
    return false
}

var copyTab = Fn.new { |t|
    var c = List.filled(t.count, null)
    for (r in 0...t.count) c[r] = t[r].toList
    return c
}

var sorted = Fn.new { |dom| (dom[0] > dom[1]) ? [dom[1], dom[0]] : dom }

var findLayouts = Fn.new { |tab, doms|
    var nrows = tab.count
    var ncols = tab[0].count
    var m = List.filled(nrows, null)
    for (i in 0...nrows) m[i] = List.filled(ncols, -1)
    var patterns = [ [m, [], []] ]
    var count = 0
    while (true) {
        var newpat = []
        for (pat in patterns) {
            var ut = pat[0]
            var ud = pat[1]
            var up = pat[2]
            var pos = null
            for (j in 0...ncols) {
                var breakOuter = false
                for (i in 0...nrows) {
                   if (ut[i][j] == -1) {
                       pos = [i, j]
                       breakOuter = true
                       break
                   }
                }
                if (breakOuter) break
            }
            if (!pos) continue
            var row = pos[0]
            var col = pos[1]
            if (row < nrows - 1 && ut[row+1][col] == -1) {
                var dom = sorted.call([tab[row][col], tab[row+1][col]])
                if (!containsDom.call(ud, dom[0], dom[1])) {
                    var newut = copyTab.call(ut)
                    newut[row][col] = tab[row][col]
                    newut[row+1][col] = tab[row+1][col]
                    newpat.add([newut, ud + [sorted.call( [tab[row][col], tab[row+1][col]])],
                        up + [row, col, row+1, col]])
                }
            }
            if (col < ncols - 1  && ut[row][col+1] == -1) {
                var dom = sorted.call([tab[row][col], tab[row][col+1]])
                if (!containsDom.call(ud, dom[0], dom[1])) {
                    var newut = copyTab.call(ut)
                    newut[row][col] = tab[row][col]
                    newut[row][col+1] = tab[row][col+1]
                    newpat.add([newut, ud + [sorted.call([tab[row][col], tab[row][col+1]])],
                        up + [row, col, row, col+1]])
                }
            }
        }
        if (newpat.count == 0) break
        patterns = newpat
        if (patterns[0][-1].count == doms.count) break
    }
    return patterns
}

var printLayout = Fn.new { |pattern|
    var tab = pattern[0]
    var dom = pattern[1]
    var pos = pattern[2]
    var bytes = List.filled(tab.count*2, null)
    for (i in 0...bytes.count) bytes[i] = List.filled(tab[0].count*2 - 1, " ")
    var idx = 0
    while (idx < pos.count-1) {
        var p = pos[idx..idx+3]
        var x1 = p[0]
        var y1 = p[1]
        var x2 = p[2]
        var y2 = p[3]
        var n1 = tab[x1][y1]
        var n2 = tab[x2][y2]
        bytes[x1*2][y1*2] = String.fromByte(48+n1)
        bytes[x2*2][y2*2] = String.fromByte(48+n2)
        if (x1 == x2) { // horizontal
            bytes[x1*2][y1*2 + 1] = "+"
        } else if (y1 == y2) { // vertical
            bytes[x1*2 + 1][y1*2] = "+"
        }
        idx = idx + 4
    }

    for (i in 0...bytes.count) {
        System.print(bytes[i].join())
    }
}

for (t in [tableau, tableau2]) {
    var start = System.clock
    var lays = findLayouts.call(t, dominoes)
    printLayout.call(lays[0])
    var lc = lays.count
    var pl = (lc > 1) ? "s" : ""
    var fo = (lc > 1) ? " (first one shown)" : ""
    System.print("%(lays.count) layout%(pl) found%(fo).")
    System.print("Took %(System.clock - start) seconds.\n")
}
