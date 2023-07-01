import "/fmt" for Fmt

var feigenbaum = Fn.new {
    var maxIt = 13
    var maxItJ = 10
    var a1 = 1
    var a2 = 0
    var d1 = 3.2
    System.print(" i       d")
    for (i in 2..maxIt) {
        var a = a1 + (a1 - a2)/d1
        for (j in 1..maxItJ) {
            var x = 0
            var y = 0
            for (k in 1..(1<<i)) {
                y = 1 - 2*y*x
                x = a - x*x
            }
            a = a - x/y
        }
        var d = (a1 - a2)/(a - a1)
        System.print("%(Fmt.d(2, i))    %(Fmt.f(0, d, 8))")
        d1 = d
        a2 = a1
        a1 = a
    }
}

feigenbaum.call()
