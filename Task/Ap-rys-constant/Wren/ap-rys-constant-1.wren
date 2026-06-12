import "./big" for BigInt, BigRat

var apery = Fn.new { |n|
    var sum = BigRat.zero
    for (k in 1..n) sum = sum + BigRat.new(1, k*k*k)
    System.print("First %(n) terms of ζ(3) truncated to 100 decimal places (accurate to 6 decimal places):")
    System.print(sum.toDecimal(100, false))
    System.print()
}

var markov = Fn.new { |n|
    var fact = BigInt.one
    var fact2 = BigInt.one
    var sign = BigInt.minusOne
    var sum = BigRat.zero
    for (k in 1..n) {
        sign = sign * BigInt.minusOne
        fact = fact * k
        var num = fact.square * sign
        var mult = 2 * k * (2*k - 1)
        fact2 = fact2 * mult
        var cube = k * k * k
        var den = fact2 * cube
        sum = sum + BigRat.new(num, den)
    }
    sum = sum * BigRat.new(5, 2)
    System.print("First %(n) terms of Markov / Apéry representation truncated to 100 decimal places:")
    System.print(sum.toDecimal(100, false))
    System.print()
}

var wedeniwski = Fn.new { |n|
    var fact = BigInt.one
    var fact2 = BigInt.one
    var sign = BigInt.minusOne
    var sum = BigRat.zero
    var mult = 1
    for (k in 0..n-1) {
        sign = sign * BigInt.minusOne
        if (k > 0) {
            fact = fact * k
            mult = 2 * k * (2*k - 1)
            fact2 = fact2 * mult
        }
        var fact3 = fact2 * (2*k + 1)
        var num = sign * fact3.cube * fact2.cube * fact.cube
        var cube = k * k * k
        var quad = cube * k
        var pent = quad * k
        var tmp =  126392*pent + 412708*quad + 531578*cube + 336367*k*k + 104000*k + 12463
        num = num * tmp
        var den = BigInt.factorial(3*k + 2) * BigInt.factorial(4*k + 3).cube
        sum = sum + BigRat.new(num, den)
    }
    sum = sum / 24
    System.print("First %(n) terms of Wedeniwski representation truncated to 100 decimal places:")
    System.print(sum.toDecimal(100, false))
    System.print()
}

System.print("Actual value to 100 decimal places:")
System.print("1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581")
System.print()
apery.call(1000)
markov.call(158)
wedeniwski.call(20)
