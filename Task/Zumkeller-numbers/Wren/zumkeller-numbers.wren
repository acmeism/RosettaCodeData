import "/math" for Int, Nums
import "/fmt" for Fmt
import "io" for Stdout

var isPartSum // recursive
isPartSum = Fn.new { |divs, sum|
    if (sum == 0) return true
    if (divs.count == 0) return false
    var last = divs[-1]
    divs = divs[0...-1]
    if (last > sum) return isPartSum.call(divs, sum)
    return isPartSum.call(divs, sum-last) || isPartSum.call(divs, sum)
}

var isZumkeller = Fn.new { |n|
    var divs = Int.divisors(n)
    var sum = Nums.sum(divs)
    // if sum is odd can't be split into two partitions with equal sums
    if (sum % 2 == 1) return false
    // if n is odd use 'abundant odd number' optimization
    if (n % 2 == 1) {
        var abundance = sum - 2 * n
        return abundance > 0 && abundance % 2 == 0
    }
    // if n and sum are both even check if there's a partition which totals sum / 2
    return isPartSum.call(divs, sum / 2)
}

System.print("The first 220 Zumkeller numbers are:")
var count = 0
var i = 2
while (count < 220) {
    if (isZumkeller.call(i)) {
        Fmt.write("$3d ", i)
        Stdout.flush()
        count = count + 1
        if (count % 20 ==  0) System.print()
    }
    i = i + 1
}

System.print("\nThe first 40 odd Zumkeller numbers are:")
count = 0
i = 3
while (count < 40) {
    if (isZumkeller.call(i)) {
        Fmt.write("$5d ", i)
        Stdout.flush()
        count = count + 1
        if (count % 10 == 0) System.print()
    }
    i = i + 2
}

System.print("\nThe first 40 odd Zumkeller numbers which don't end in 5 are:")
count = 0
i = 3
while (count < 40) {
    if ((i % 10 != 5) && isZumkeller.call(i)) {
        Fmt.write("$7d ", i)
        Stdout.flush()
        count = count + 1
        if (count % 8 == 0) System.print()
    }
    i = i + 2
}
System.print()
