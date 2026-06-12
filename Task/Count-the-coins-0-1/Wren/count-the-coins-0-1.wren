import "./fmt" for Fmt
import "./math" for Int

var cnt  = 0 // order unimportant
var cnt2 = 0 // order important
var wdth = 0 // for printing purposes

var count // recursive
count = Fn.new { |want, used, sum, have, uindices, rindices|
    if (sum == want) {
        cnt = cnt + 1
        cnt2 = cnt2 + Int.factorial(used.count)
        if (cnt < 11) Fmt.print("  indices $*n => used $n", wdth, uindices, used)
    } else if (sum < want && !have.isEmpty) {
        var thisCoin = have[0]
        var index = rindices[0]
        var rest = have.skip(1).toList
        var rindices = rindices.skip(1).toList
        count.call(want, used + [thisCoin], sum + thisCoin, rest, uindices + [index], rindices)
        count.call(want, used, sum, rest, uindices, rindices)
    }
}

var countCoins = Fn.new { |want, coins, width|
    System.print("Sum %(want) from coins %(coins)")
    cnt  = 0
    cnt2 = 0
    wdth = -width
    count.call(want, [], 0, coins, [], (0...coins.count).toList)
    if (cnt > 10) {
        System.print("  .......")
        System.print("  (only the first 10 ways generated are shown)")
    }
    System.print("Number of ways - order unimportant : %(cnt) (as above)")
    System.print("Number of ways - order important   : %(cnt2) (all perms of above indices)\n")
}

countCoins.call(6, [1, 2, 3, 4, 5], 9)
countCoins.call(6, [1, 1, 2, 3, 3, 4, 5], 9)
countCoins.call(40, [1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100], 28)
