import "random" for Random
import "./fmt" for Fmt

var nmax = 20
var rand = Random.new()

var avg = Fn.new { |n|
    var tests = 1e4
    var sum = 0
    for (t in 0...tests) {
        var v = List.filled(nmax, false)
        var x = 0
        while (!v[x]) {
            v[x] = true
            sum = sum + 1
            x = rand.int(n)
        }
    }
    return sum/tests
}

var ana = Fn.new { |n|
    if (n < 2) return 1
    var term = 1
    var sum = 1
    for (i in n-1..1) {
        term = term * i / n
        sum = sum + term
    }
    return sum
}

System.print(" N    average    analytical    (error)")
System.print("===  =========  ============  =========")
for (n in 1..nmax) {
    var a = avg.call(n)
    var b = ana.call(n)
    var e = (a - b).abs/ b * 100
    Fmt.print("$3d $9.4f  $12.4f   ($6.2f\%)", n, a, b, e)
}
