var digits = "0123456789abcdef"
var base = 16
var size = 15
var comDiv = 15 * 14 * 13 * 12 * 11

// Returns n mod k, where n is an array and k is a number
var hexMod = Fn.new { |n, k|
    var r = 0
    for (i in size..1) r = (r*base + n[i]) % k
    return r
}

// Calculates n = n - m, where n is an array and m is a number
var hexSub = Fn.new { |n, m|
    var i = 1
    while (m != 0 && i <= size) {
        n[i] = n[i] - (m%base)
        m = (m/base).floor
        if (n[i] < 0) {
            n[i] = n[i] + base
            m = m + 1
        }
        i = i + 1
    }
}

// Returns true if n is an array of unique digits in range 1..(base-1)
var hasUniqueDigits = Fn.new { |n|
    var dcount = List.filled(base, 0)
    for (i in 1..size) {
        var d = n[i]
        if (d == 0) return false // can't contain '0'
        dcount[d] = dcount[d] + 1
        if (dcount[d] > 1) return false // digits must be unique
    }
    return true
}

var solve = Fn.new { |n|
    var r = hexMod.call(n, comDiv)
    hexSub.call(n, r)
    while (n[size] > 0) {
        if (hasUniqueDigits.call(n)) {
            System.write("Largest hex number is ")
            for (i in size..1) System.write(digits[n[i]])
            System.print()
            return
        }
        hexSub.call(n, comDiv)
    }
}

var startN = List.filled(size + 1, 0)
for (i in 1..size) startN[i] = i
solve.call(startN)
