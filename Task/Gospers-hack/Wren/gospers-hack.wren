var gospersHack = Fn.new { |x|
    var c = x & -x
    var r = x + c
    return (((r ^ x) >> 2) / c).floor | r
}

for (start in [1, 3, 7, 15]) {
    var x = start
    var results = []
    for (i in 0..9) {
        x = gospersHack.call(x)
        results.add(x)
    }
    System.print("%(start): %(results.join(" "))")
}
