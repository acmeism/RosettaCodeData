import "/fmt" for Fmt
import "/math" for Int, Nums

var sumStr = Fn.new { |divs| divs.reduce("") { |acc, div| acc + "%(div) + " }[0...-3] }

var abundantOdd = Fn.new { |searchFrom, countFrom, countTo, printOne|
    var count = countFrom
    var n = searchFrom
    while (count < countTo) {
        var divs = Int.properDivisors(n)
        var tot = Nums.sum(divs)
        if (tot > n) {
            count = count + 1
            if (!printOne || count >= countTo) {
                var s = sumStr.call(divs)
                if (!printOne) {
                    System.print("%(Fmt.d(2, count)). %(Fmt.d(5, n)) < %(s) = %(tot)")
                } else {
                    System.print("%(n) < %(s) = %(tot)")
                }
            }
        }
        n = n + 2
    }
    return n
}

var MAX = 25
System.print("The first %(MAX) abundant odd numbers are:")
var n = abundantOdd.call(1, 0, 25, false)

System.print("\nThe one thousandth abundant odd number is:")
abundantOdd.call(n, 25, 1000, true)

System.print("\nThe first abundant odd number above one billion is:")
abundantOdd.call(1e9+1, 0, 1, true)
