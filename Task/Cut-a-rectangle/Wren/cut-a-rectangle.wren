import "./fmt" for Fmt

var grid = []
var w = 0
var h = 0
var len = 0
var cnt = 0
var next = [0] * 4
var dir  = [[0, -1], [-1, 0], [0, 1], [1, 0]]

var walk // recursive
walk = Fn.new { |y, x|
    if (y == 0 || y == h || x == 0 || x == w) {
        cnt = cnt + 2
        return
    }
    var t = y * (w + 1) + x
    grid[t] = grid[t] + 1
    grid[len-t] = grid[len-t] + 1
    for (i in 0..3) {
        if (grid[t + next[i]] == 0) {
            walk.call(y + dir[i][0], x + dir[i][1])
        }
    }
    grid[t] = grid[t] - 1
    grid[len-t] = grid[len-t] - 1
}

var solve // recursive
solve = Fn.new { |hh, ww, recur|
    h = hh
    w = ww
    if (h&1 != 0) {
        var t = w
        w = h
        h = t
    }
    if (h&1 != 0) return 0
    if (w == 1) return 1
    if (w == 2) return h
    if (h == 2) return w
    var cy = (h/2).floor
    var cx = (w/2).floor
    len = (h + 1) * (w + 1)
    grid = List.filled(len, 0)
    len  = len - 1
    next[0] = -1
    next[1] = -w - 1
    next[2] = 1
    next[3] = w + 1
    if (recur) cnt = 0
    var x = cx + 1
    while (x < w) {
        var t = cy * (w + 1) + x
        grid[t] = 1
        grid[len-t] = 1
        walk.call(cy - 1, x)
        x = x + 1
    }
    cnt = cnt + 1
    if (h == w) {
        cnt = cnt * 2
    } else if ((w&1 == 0) && recur) {
        solve.call(w, h, false)
    }
    return cnt
}

for (y in 1..10) {
    for (x in 1..y) {
        if ((x&1 == 0) || (y&1 ==0)) {
            Fmt.print("$2d x $2d : $d", y, x, solve.call(y, x, true))
        }
    }
}
