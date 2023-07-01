import "random" for Random
import "/fmt" for Fmt

var rand = Random.new()
var RAND_MAX = 32767
var EMPTY = ""

var x = 15
var y = 15
var grid = List.filled((x + 1) * (y + 1) + 1, EMPTY)
var cell = 0
var end = 0
var m = 0
var n = 0

var makeGrid = Fn.new { |p|
    var thresh = (p * RAND_MAX).truncate
    m = x
    n = y
    grid.clear()
    grid = List.filled(m + 1, EMPTY)
    end = m + 1
    cell = m + 1
    for (i in 0...n) {
        for (j in 0...m) {
            var r = rand.int(RAND_MAX+1)
            grid.add((r < thresh) ? "+" : ".")
            end = end + 1
        }
        grid.add("\n")
        end = end + 1
    }
    grid[end-1] = EMPTY
    m = m + 1
    end = end - m  // end is the index of the first cell of bottom row
}

var ff // recursive
ff = Fn.new { |p|  // flood fill
   if (grid[p] != "+") return false
   grid[p] = "#"
   return p >= end || ff.call(p + m) || ff.call(p + 1) || ff.call(p - 1) ||
        ff.call(p - m)
}

var percolate = Fn.new {
    var i = 0
    while (i < m && !ff.call(cell + i)) i = i + 1
    return i < m
}

makeGrid.call(0.5)
percolate.call()
System.print("%(x) x %(y) grid:")
System.print(grid.join(""))
System.print("\nRunning 10,000 tests for each case:")
for (ip in 0..10) {
    var p = ip / 10
    var cnt = 0
    for (i in 0...10000) {
        makeGrid.call(p)
        if (percolate.call()) cnt = cnt + 1
    }
    Fmt.print("p = $.1f:  $.4f", p, cnt / 10000)
}
