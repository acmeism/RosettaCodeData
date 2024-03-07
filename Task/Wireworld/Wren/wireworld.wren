import "./fmt" for Fmt
import "./ioutil" for FileUtil, Stdin

var rows = 0     // extent of input configuration
var cols = 0     // """
var rx   = 0     // grid extent (includes border)
var cx   = 0     // """
var mn   = []    // offsets of Moore neighborhood

var print = Fn.new { |grid|
    System.print("__" * cols)
    System.print()
    for (r in 1..rows) {
        for (c in 1..cols) Fmt.write(" $s", grid[r*cx+c])
        System.print()
    }
}

var step = Fn.new { |dst, src|
    for (r in 1..rows) {
        for (c in 1..cols) {
            var x = r*cx + c
            dst[x] = src[x]
            if (dst[x] == "H") {
                dst[x] = "t"
            } else if (dst[x] == "t") {
                dst[x] = "."
            } else if (dst[x] == ".") {
                var nn = 0
                for (n in mn) {
                    if (src[x+n] == "H") nn = nn + 1
                }
                if (nn == 1 || nn == 2) dst[x] = "H"
            }
        }
    }
}

var srcRows = FileUtil.readLines("ww.config")
rows = srcRows.count
for (r in srcRows) {
    if (r.count > cols) cols = r.count
}
rx = rows + 2
cx = cols + 2
mn = [-cx-1, -cx, -cx+1, -1, 1, cx-1, cx, cx+1]

// allocate two grids and copy input into first grid
var odd  = List.filled(rx*cx, " ")
var even = List.filled(rx*cx, " ")

var ri = 0
for (r in srcRows) {
    for (i in 0...r.count) {
        odd[(ri+1)*cx+1+i] = r[i]
    }
    ri = ri + 1
}

// run
while (true) {
    print.call(odd)
    step.call(even, odd)
    Stdin.readLine() // wait for enter to be pressed

    print.call(even)
    step.call(odd, even)
    Stdin.readLine() // ditto
}
