import "./ioutil" for Input
import "./fmt" for Fmt

// Inserts item x in list a, and keeps it sorted assuming a is already sorted.
// If x is already in a, inserts it to the right of the rightmost x.
var insortRight = Fn.new{ |a, x, q|
    var lo = 0
    var hi = a.count
    while (lo < hi) {
        var mid = ((lo + hi)/2).floor
        q = q + 1
        var prompt = Fmt.swrite("$2d: Is $6s less than $6s ? y/n: ", q, x, a[mid])
        var less = Input.option(prompt, "yn") == "y"
        if (less) {
            hi = mid
        } else {
            lo = mid + 1
        }
     }
     a.insert(lo, x)
     return q
}

var order = Fn.new { |items|
    var ordered = []
    var q = 0
    for (item in items) {
        q = insortRight.call(ordered, item, q)
    }
    return ordered
}

var items = "violet red green indigo blue yellow orange".split(" ")
var ordered = order.call(items)
System.print("\nThe colors of the rainbow, in sorted order, are:")
System.print(ordered)
