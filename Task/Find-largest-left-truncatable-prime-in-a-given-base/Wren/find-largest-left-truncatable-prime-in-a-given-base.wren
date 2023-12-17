import "./big" for BigInt
import "./fmt" for Conv, Fmt
import "./sort" for Sort
import "./ioutil" for Input

var nextLeftTruncatablePrimes = Fn.new { |n, radix, certainty|
    var probablePrimes = []
    var baseString = (n == BigInt.zero) ? "" : n.toBaseString(radix)
    for (i in 1...radix) {
        var p = BigInt.fromBaseString(Conv.itoa(i, radix) + baseString, radix)
        if (p.isProbablePrime(certainty)) probablePrimes.add(p)
    }
    return probablePrimes
}

var largestLeftTruncatablePrime = Fn.new { |radix, certainty|
    var lastList = null
    var list = nextLeftTruncatablePrimes.call(BigInt.zero, radix, certainty)
    while (!list.isEmpty) {
        lastList = list
        list = []
        for (n in lastList) list.addAll(nextLeftTruncatablePrimes.call(n, radix, certainty))
    }
    if (!lastList) return null
    Sort.quick(lastList)
    return lastList[-1]
}

var maxRadix  = Input.integer("Enter maximum radix : ", 3, 36)
var certainty = Input.integer("Enter certainty     : ", 1, 100)
System.print()
for (radix in 3..maxRadix) {
    var largest = largestLeftTruncatablePrime.call(radix, certainty)
    Fmt.write("Base = $-2d : ", radix)
    if (!largest) {
        System.print("No left truncatable prime")
    } else {
        Fmt.print("$-35i -> $s", largest, largest.toBaseString(radix))
    }
}
