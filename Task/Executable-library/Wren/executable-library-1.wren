/* hailstone.wren */

var Hailstone = Fn.new { |n|
    if (n < 1) Fiber.abort("Parameter must be a positive integer.")
    var h = [n]
    while (n != 1) {
        n = (n%2 == 0) ? (n/2).floor : 3*n + 1
        h.add(n)
    }
    return h
}

var libMain_ = Fn.new {
    var h = Hailstone.call(27)
    System.print("For the Hailstone sequence starting with n = 27:")
    System.print("   Number of elements  = %(h.count)")
    System.print("   First four elements = %(h[0..3])")
    System.print("   Final four elements = %(h[-4..-1])")

    System.print("\nThe Hailstone sequence for n < 100,000 with the longest length is:")
    var longest = 0
    var longlen = 0
    for (n in 1..99999) {
        var h = Hailstone.call(n)
        var c = h.count
        if (c > longlen) {
            longest = n
            longlen = c
        }
    }
    System.print("   Longest = %(longest)")
    System.print("   Length  = %(longlen)")
}

// Check if it's being used as a library or not.
import "os" for Process
if (Process.allArguments[1] == "hailstone.wren") {  // if true, not a library
    libMain_.call()
}
