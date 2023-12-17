/* Juggler_sequence_2.wren */

import "./gmp" for Mpz
import "./fmt" for Fmt

var one  = Mpz.one

var juggler = Fn.new { |n|
    if (n < 1) Fiber.abort("Starting value must be a positive integer.")
    var a = Mpz.from(n)
    var count = 0
    var maxCount = 0
    var max = a.copy()
    while (a != one) {
        if (a.isEven) {
            a.sqrt
        } else {
            a.cube.sqrt
        }
        count = count + 1
        if (a > max) {
            max.set(a)
            maxCount = count
        }
    }
    return [count, maxCount, max, max.toString.count]
}

System.print("n    l[n]  i[n]  h[n]")
System.print("-----------------------------------")
for (n in 20..39) {
    var res = juggler.call(n)
    Fmt.print("$2d    $2d   $2d    $,i", n, res[0], res[1], res[2])
}
System.print()
var nums = [
    113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443,
    275485, 1267909, 2264915, 5812827, 7110201
]

System.print("     n      l[n]   i[n]   d[n]")
System.print("-----------------------------------")
for (n in nums) {
    var res = juggler.call(n)
    Fmt.print("$,9d   $3d    $3d    $,i", n, res[0], res[1], res[3])
}
