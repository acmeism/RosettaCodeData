import "random" for Random
import "/sort" for Sort
import "/fmt" for Fmt

var r = Random.new()

var dice5 = Fn.new { r.int(1, 6) }

var dice7 = Fn.new {
    while (true) {
        var t = (dice5.call() - 1) * 5 + dice5.call() - 1
        if (t < 21) return 1 + (t/3).floor
    }
}

var checkDist = Fn.new { |gen, nRepeats, tolerance|
    var occurs = {}
    for (i in 1..nRepeats) {
        var d = gen.call()
        occurs[d] = occurs.containsKey(d) ? occurs[d] + 1 : 1
    }
    var expected = (nRepeats/occurs.count).floor
    var maxError = (expected * tolerance / 100).floor
    System.print("Repetitions = %(nRepeats), Expected = %(expected)")
    System.print("Tolerance = %(tolerance)\%, Max Error = %(maxError)\n")
    System.print("Integer   Occurrences   Error  Acceptable")
    var f = "  $d        $5d      $5d     $s"
    var allAcceptable = true
    var cmp = Fn.new { |me1, me2| (me1.key - me2.key).sign }
    occurs = occurs.toList
    Sort.insertion(occurs, cmp)
    for (me in occurs) {
        var k = me.key
        var v = me.value
        var error = (v - expected).abs
        var acceptable = (error <= maxError) ? "Yes" : "No"
        if (acceptable == "No") allAcceptable = false
        Fmt.print(f, k, v, error, acceptable)
    }
    System.print("\nAcceptable overall: %(allAcceptable ? "Yes" : "No")")
}

checkDist.call(dice7, 1400000, 0.5)
