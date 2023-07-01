let mean = 1.0
let stdv = 0.5
let count = 1000

// stats computes a running mean and variance
// See Knuth TAOCP vol 2, 3rd edition, page 232

def stats(xs: [float]) -> float, float: // variance, mean
    var M = xs[0]
    var S = 0.0
    var n = 1.0
    for(xs.length - 1) i:
        let x = xs[i + 1]
        n = n + 1.0
        let mm = (x - M)
        M += mm / n
        S += mm * (x - M)
    return (if n > 0.0: S / n else: 0.0), M

def test_random_normal() -> [float]:
    rnd_seed(floor(seconds_elapsed() * 1000000))
    let r = vector_reserve(typeof return, count)
    for (count):
        r.push(rnd_gaussian() * stdv + mean)
    let cvar, cmean = stats(r)
    let cstdv = sqrt(cvar)
    print concat_string(["Mean: ", string(cmean), ", Std.Deviation: ", string(cstdv)], "")

test_random_normal()
