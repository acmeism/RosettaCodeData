import "./fmt" for Fmt

var gBase32 = "0123456789bcdefghjkmnpqrstuvwxyz"

var encodeGeohash = Fn.new { |location, prec|
    var latRange = -90..90
    var lngRange = -180..180
    var hash = ""
    var hashVal = 0
    var bits = 0
    var even = true
    while (hash.count < prec) {
        var val = even ? location[1] : location[0]
        var rng = even ? lngRange : latRange
        var mid = (rng.from + rng.to) / 2
        if (val > mid) {
            hashVal = hashVal*2 + 1
            rng = mid..rng.to
            if (even) lngRange = mid..lngRange.to else latRange = mid..latRange.to
        } else {
            hashVal = hashVal * 2
            if (even) lngRange = lngRange.from..mid else latRange = latRange.from..mid
        }
        even = !even
        if (bits < 4) {
            bits = bits + 1
        } else {
            bits = 0
            hash = hash + gBase32[hashVal]
            hashVal = 0
        }
    }
    return hash
}

var data = [
    [[51.433718, -0.214126], 2],
    [[51.433718, -0.214126], 9],
    [[57.64911,  10.40744 ], 11]
]

for (d in data) {
    var geohash = encodeGeohash.call(d[0], d[1])
    var loc = "[%(Fmt.f(9, d[0][0], 6)), %(Fmt.f(9, d[0][1], 6))]"
    System.print("geohash for %(loc), precision %(Fmt.d(-2, d[1])) = %(geohash)")
}
