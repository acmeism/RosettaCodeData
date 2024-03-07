import "random" for Random
import "./fmt" for Fmt
import "./math" for Nums

var rgen = Random.new()

// Box-Muller method from Wikipedia
var normal  = Fn.new { |mu, sigma|
    var u1  = rgen.float()
    var u2  = rgen.float()
    var mag = sigma * (-2 * u1.log).sqrt
    var z0  = mag * (2 * Num.pi * u2).cos + mu
    var z1  = mag * (2 * Num.pi * u2).sin + mu
    return [z0, z1]
}

var N = 100000
var NUM_BINS = 12
var HIST_CHAR = "■"
var HIST_CHAR_SIZE = 250
var bins = List.filled(NUM_BINS, 0)
var binSize = 0.1
var samples = List.filled(N, 0)
var mu = 0.5
var sigma = 0.25
for (i in 0...N/2) {
    var rns = normal.call(mu, sigma)
    for (j in 0..1) {
        var rn = rns[j]
        var bn
        if (rn < 0) {
            bn = 0
        } else if (rn >= 1) {
            bn = 11
        } else {
            bn = (rn/binSize).floor + 1
        }
        bins[bn] = bins[bn] + 1
        samples[i*2 + j] = rn
    }
}

Fmt.print("Normal distribution with mean $0.2f and S/D $0.2f for $,d samples:\n", mu, sigma, N)
System.print("    Range           Number of samples within that range")
for (i in 0...NUM_BINS) {
    var hist = HIST_CHAR * (bins[i] / HIST_CHAR_SIZE).round
    if (i == 0) {
        Fmt.print("  -∞ ..< 0.00  $s $,d", hist, bins[0])
    } else if (i < NUM_BINS - 1) {
        Fmt.print("$4.2f ..< $4.2f  $s $,d", binSize * (i-1), binSize * i, hist, bins[i])
    } else {
        Fmt.print("1.00 ... +∞    $s $,d", hist, bins[NUM_BINS - 1])
    }
}
Fmt.print("\nActual mean for these samples : $0.5f", Nums.mean(samples))
Fmt.print("Actual S/D  for these samples : $0.5f", Nums.stdDev(samples))
