import "/big" for BigInt, BigRat

var isPowerOfTwo = Fn.new { |bi| bi & (bi - BigInt.one) == BigInt.zero }

var fractran = Fn.new { |program, n, limit, primesOnly|
    var fractions = program.split(" ").where { |s| s != "" }
                                      .map { |s| BigRat.fromRationalString(s) }
                                      .toList
    var results = []
    if (!primesOnly) results.add(n)
    var nn = BigInt.new(n)
    while (results.count < limit) {
        var fracs = fractions.where { |f| (f * nn).isInteger }.toList
        if (fracs.count == 0) break
        var frac = fracs[0]
        nn = nn * frac.num / frac.den
        if (!primesOnly) {
            results.add(nn.toSmall)
        } else if (primesOnly && isPowerOfTwo.call(nn)) {
            var prime = (nn.toNum.log / 2.log).floor
            results.add(prime)
        }
    }
    return results
}

var program = "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
System.print("First twenty numbers:")
System.print(fractran.call(program, 2, 20, false))
System.print("\nFirst ten primes:")
System.print(fractran.call(program, 2, 10, true))
