// Stats computes a running mean and variance
// See Knuth TAOCP vol 2, 3rd edition, page 232

class Stats:
    M = 0.0
    S = 0.0
    n = 0
    def incl(x):
        n += 1
        if n == 1:
            M = x
        else:
            let mm = (x - M)
            M += mm / n
            S += mm * (x - M)
    def mean(): return M
    //def variance(): return (if n > 1.0: S / (n - 1.0) else: 0.0) // Bessel's correction
    def variance(): return (if n > 0.0: S / n else: 0.0)
    def stddev(): return sqrt(variance())
    def count(): return n

def test_stdv() -> float:
    let v = [2,4,4,4,5,5,7,9]
    let s = Stats {}
    for(v) x: s.incl(x+0.0)
    print concat_string(["Mean: ", string(s.mean()), ", Std.Deviation: ", string(s.stddev())], "")

test_stdv()
