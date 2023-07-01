var mianChowla = Fn.new { |n|
    var mc = List.filled(n, 0)
    var sums = {}
    var ts = {}
    mc[0] = 1
    sums[2] = true
    for (i in 1...n) {
        var j = mc[i-1] + 1
        while (true) {
            mc[i] = j
            for (k in 0..i) {
                var sum = mc[k] + j
                if (sums[sum]) {
                    ts.clear()
                    break
                }
                ts[sum] = true
            }
            if (ts.count > 0) {
                for (key in ts.keys) sums[key] = true
                break
            }
            j = j + 1
        }
    }
    return mc
}

var start = System.clock
var mc = mianChowla.call(100)
System.print("The first 30 terms of the Mian-Chowla sequence are:\n%(mc[0..29].join(" "))")
System.print("\nTerms 91 to 100 of the Mian-Chowla sequence are:\n%(mc[90..99].join(" "))")
System.print("\nTook %(((System.clock - start)*1000).round) milliseconds")
