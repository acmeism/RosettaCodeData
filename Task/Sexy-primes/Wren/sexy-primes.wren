import "/fmt" for Fmt
import "/math" for Int

var printHelper = Fn.new { |cat, le, lim, max|
    var cle = Fmt.commatize(le)
    var clim = Fmt.commatize(lim)
    if (cat != "unsexy primes") cat = "sexy prime " + cat
    System.print("Number of %(cat) less than %(clim) = %(cle)")
    var last = (le < max) ? le : max
    var verb = (last == 1) ? "is" : "are"
    return [le, last, verb]
}

var lim = 1000035
var sv = Int.primeSieve(lim-1, false)
var pairs = []
var trips = []
var quads = []
var quins = []
var unsexy = [2, 3]
var i = 3
while (i < lim) {
    if (i > 5 && i < lim-6 && !sv[i] && sv[i-6] && sv[i+6]) {
        unsexy.add(i)
    } else {
        if (i < lim-6 && !sv[i] && !sv[i+6]) {
            pairs.add([i, i+6])
            if (i < lim-12 && !sv[i+12]) {
                trips.add([i, i+6, i+12])
                if (i < lim-18 && !sv[i+18]) {
                    quads.add([i, i+6, i+12, i+18])
                    if (i < lim-24 && !sv[i+24]) {
                        quins.add([i, i+6, i+12, i+18, i+24])
                    }
                }
            }
        }
    }
    i = i + 2
}
var le
var n
var verb
var unwrap = Fn.new { |t|
    le = t[0]
    n = t[1]
    verb = t[2]
}

unwrap.call(printHelper.call("pairs", pairs.count, lim, 5))
System.print("The last %(n) %(verb):\n  %(pairs[le-n..-1])\n")

unwrap.call(printHelper.call("triplets", trips.count, lim, 5))
System.print("The last %(n) %(verb):\n  %(trips[le-n..-1])\n")

unwrap.call(printHelper.call("quadruplets", quads.count, lim, 5))
System.print("The last %(n) %(verb):\n  %(quads[le-n..-1])\n")

unwrap.call(printHelper.call("quintuplets", quins.count, lim, 5))
System.print("The last %(n) %(verb):\n  %(quins[le-n..-1])\n")

unwrap.call(printHelper.call("unsexy primes", unsexy.count, lim, 10))
System.print("The last %(n) %(verb):\n  %(unsexy[le-n..-1])\n")
