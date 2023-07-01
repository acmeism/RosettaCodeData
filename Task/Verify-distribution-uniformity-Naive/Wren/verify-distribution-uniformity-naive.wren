import "random" for Random
import "/fmt" for Fmt
import "/sort" for Sort

var r = Random.new()

var dice5 = Fn.new { 1 + r.int(5) }

var checkDist = Fn.new { |gen, nRepeats, tolerance|
    var occurs = {}
    for (i in 1..nRepeats) {
        var d = gen.call()
        occurs[d] = occurs.containsKey(d) ? occurs[d] + 1 : 1
    }
    var expected = (nRepeats/occurs.count).floor
    var maxError = (expected*tolerance/100).floor
    System.print("Repetitions = %(nRepeats), Expected = %(expected)")
    System.print("Tolerance = %(tolerance)\%, Max Error = %(maxError)\n")
    System.print("Integer   Occurrences   Error  Acceptable")
    var f = "  $d        $5d      $5d     $s"
    var allAcceptable = true
    occurs = occurs.toList
    Sort.quick(occurs)
    for (me in occurs) {
        var error = (me.value - expected).abs
        var acceptable = (error <= maxError) ? "Yes" : "No"
        if (acceptable == "No") allAcceptable = false
        Fmt.print(f, me.key, me.value, error, acceptable)
    }
    System.print("\nAcceptable overall: %(allAcceptable ? "Yes" : "No")")
}

checkDist.call(dice5, 1e6, 0.5)
System.print()
checkDist.call(dice5, 1e5, 0.5)
