import "random" for Random
import "io" for Stdin

var rand = Random.new()
var rows = 20
var cols = 30
var p    = 0.01
var f    = 0.001
var rx   = rows + 2
var cx   = cols + 2

var step = Fn.new { |dst, src|
    for (r in 1..rows) {
        for (c in 1..cols) {
            var x = r*cx + c
            dst[x] = src[x]
            if (dst[x] == "#") {
                // rule 1. A burning cell turns into an empty cell
                dst[x] = " "
            } else if(dst[x] == "T") {
                // rule 2. A tree will burn if at least one neighbor is burning
                if (src[x-cx-1] == "#"  || src[x-cx] == "#" || src[x-cx+1] == "#" ||
                    src[x-1] == "#"     || src[x+1] == "#"  ||
                    src[x+cx-1] == "#"  || src[x+cx] == "#" || src[x+cx+1] == "#") {
                    dst[x] = "#"
                    // rule 3. A tree ignites with probability f
                    // even if no neighbor is burning
                } else if (rand.float() < f) {
                    dst[x] = "#"
                }
            } else {
                // rule 4. An empty space fills with a tree with probability p
                if (rand.float() < p) dst[x] = "T"
            }
        }
    }
}

var print = Fn.new { |model|
    System.print("__" * cols)
    System.print()
    for (r in 1..rows) {
        for (c in 1..cols) System.write(" %(model[r*cx+c])")
        System.print()
    }
}

var odd  = List.filled(rx*cx, " ")
var even = List.filled(rx*cx, " ")
for (r in 1 ..rows) {
    for (c in 1..cols) {
        if (rand.int(2) == 1) odd[r*cx+c] = "T"
    }
}
while (true) {
    print.call(odd)
    step.call(even, odd)
    Stdin.readLine()

    print.call(even)
    step.call(odd, even)
    Stdin.readLine()
}
