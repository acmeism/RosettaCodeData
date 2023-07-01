import "/fmt" for Fmt

var limit = 50000
var divs = []
var subs = []
var mins = []

// Assumes the numbers are presented in order up to 'limit'.
var minsteps = Fn.new { |n|
    if (n == 1) {
        mins[1] = []
        return
    }
    var min = limit
    var p = 0
    var q = 0
    var op = ""
    for (div in divs) {
        if (n%div == 0) {
            var d = (n/div).floor
            var steps = mins[d].count + 1
            if (steps < min) {
                min = steps
                p = d
                q = div
                op = "/"
            }
        }
    }
    for (sub in subs) {
        var d = n - sub
        if (d >= 1) {
            var steps = mins[d].count + 1
            if (steps < min) {
                min = steps
                p = d
                q = sub
                op = "-"
            }
        }
    }
    mins[n].add("%(op)%(q) -> %(p)")
    mins[n].addAll(mins[p])
}

for (r in 0..1) {
    divs = [2, 3]
    subs = (r == 0) ? [1] : [2]
    mins = List.filled(limit+1, null)
    for (i in 0..limit) mins[i] = []
    Fmt.print("With: Divisors: $n, Subtractors: $n =>", divs, subs)
    System.print("  Minimum number of steps to diminish the following numbers down to 1 is:")
    for (i in 1..limit) {
        minsteps.call(i)
        if (i <= 10) {
            var steps = mins[i].count
            var plural = (steps == 1) ? " " : "s"
            var mi = Fmt.v("s", 0, mins[i], 0, ", ", "")
            Fmt.print("    $2d: $d step$s: $s", i, steps, plural, mi)
        }
    }
    for (lim in [2000, 20000, 50000]) {
        var max = 0
        for (min in mins[0..lim]) {
            var m = min.count
            if (m > max) max = m
        }
        var maxs = []
        var i = 0
        for (min in mins[0..lim]) {
            if (min.count == max) maxs.add(i)
            i = i + 1
        }
        var nums = maxs.count
        var verb   = (nums == 1) ? "is" : "are"
        var verb2  = (nums == 1) ? "has" : "have"
        var plural = (nums == 1) ? "": "s"
        Fmt.write("  There $s $d number$s in the range 1-$d ", verb, nums, plural, lim)
        Fmt.print("that $s maximum 'minimal steps' of $d:", verb2, max)
        System.print("   %(maxs)")
    }
    System.print()
}
