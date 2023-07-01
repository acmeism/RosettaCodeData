import "/fmt" for Fmt

var a = 0
var b = 0
var c = 0
var d = 0
var e = 0
var f = 0
var g = 0

var lo
var hi
var unique
var show
var solutions

var bf = Fn.new {
    f = lo
    while (f <= hi) {
        if (!unique || (f != a && f != c && f != d && f != e && f != g)) {
            b = e + f - c
            if (b >= lo && b <= hi &&
               (!unique || (b != a && b != c && b != d && b != e && b != f && b != g))) {
                    solutions = solutions + 1
                    if (show) Fmt.lprint("$d $d $d $d $d $d $d", [a, b, c, d, e, f, g])
            }
        }
        f = f + 1
    }
}

var ge = Fn.new {
    e = lo
    while (e <= hi) {
        if (!unique || (e != a && e != c && e != d)) {
            g = d + e
            if (g >= lo && g <= hi &&
                (!unique || (g != a && g != c && g != d && g != e))) bf.call()
        }
        e = e + 1
    }
}

var acd = Fn.new {
    c = lo
    while (c <= hi) {
        d = lo
        while (d <= hi) {
            if (!unique || c != d) {
                a = c + d
                if (a >= lo && a <= hi && (!unique || (c != 0 && d != 0))) ge.call()
            }
            d = d + 1
        }
        c = c + 1
    }
}

var foursquares = Fn.new { |plo, phi, punique, pshow|
    lo = plo
    hi = phi
    unique = punique
    show = pshow
    solutions = 0
    if (show) {
        System.print("\na b c d e f g")
        System.print("-------------")
    }
    acd.call()
    if (unique) {
        Fmt.print("\n$d unique solutions in $d to $d", solutions, lo, hi)
    } else {
        Fmt.print("\n$d non-unique solutions in $d to $d\n", solutions, lo, hi)
    }
}

foursquares.call(1, 7, true, true)
foursquares.call(3, 9, true, true)
foursquares.call(0, 9, false, false)
