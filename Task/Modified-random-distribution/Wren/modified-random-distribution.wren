import "random" for Random
import "./fmt" for Fmt

var rgen = Random.new()

var rng = Fn.new { |modifier|
    while (true) {
        var r1 = rgen.float()
        var r2 = rgen.float()
        if (r2 < modifier.call(r1)) {
            return r1
        }
    }
}

var modifier = Fn.new { |x| (x < 0.5) ? 2 * (0.5 - x) : 2 * (x - 0.5) }

var N = 100000
var NUM_BINS = 20
var HIST_CHAR = "■"
var HIST_CHAR_SIZE = 125
var bins = List.filled(NUM_BINS, 0)
var binSize = 1 / NUM_BINS
for (i in 0...N) {
    var rn = rng.call(modifier)
    var bn = (rn / binSize).floor
    bins[bn] = bins[bn] + 1
}

Fmt.print("Modified random distribution with $,d samples in range [0, 1):\n", N)
System.print("    Range           Number of samples within that range")
for (i in 0...NUM_BINS) {
    var hist = HIST_CHAR * (bins[i] / HIST_CHAR_SIZE).round
    Fmt.print("$4.2f ..< $4.2f  $s $,d", binSize * i, binSize * (i + 1), hist, bins[i])
}
