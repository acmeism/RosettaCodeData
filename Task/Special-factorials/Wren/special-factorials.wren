import "./big" for BigInt
import "./fmt" for Fmt

var sf = Fn.new { |n|
    if (n < 2) return BigInt.one
    var sfact = BigInt.one
    var fact  = BigInt.one
    for (i in 2..n) {
        fact = fact * i
        sfact = sfact * fact
    }
    return sfact
}

var H = Fn.new { |n|
    if (n < 2) return BigInt.one
    var hfact = BigInt.one
    for (i in 2..n) hfact = hfact * BigInt.new(i).pow(i)
    return hfact
}

var af = Fn.new { |n|
    if (n < 1) return BigInt.zero
    var afact = BigInt.zero
    var fact  = BigInt.one
    var sign  = (n%2 == 0) ? -1 : 1
    for (i in 1..n) {
        fact = fact * i
        afact = afact + fact * sign
        sign = -sign
    }
    return afact
}

var ef // recursive
ef = Fn.new { |n|
    if (n < 1) return BigInt.one
    return BigInt.new(n).pow(ef.call(n-1))
}

var rf = Fn.new { |n|
    var i = 0
    var fact = BigInt.one
    while (true) {
        if (fact == n) return i
        if (fact > n)  return "none"
        i = i + 1
        fact = fact * i
    }
}

System.print("First 10 superfactorials:")
for (i in 0..9) System.print(sf.call(i))

System.print("\nFirst 10 hyperfactorials:")
for (i in 0..9) System.print(H.call(i))

System.print("\nFirst 10 alternating factorials:")
for (i in 0..9) System.write("%(af.call(i)) ")

System.print("\n\nFirst 5 exponential factorials:")
for (i in 0..4) System.write("%(ef.call(i)) ")
System.print()

Fmt.print("\nThe number of digits in 5$$ is $,d\n", ef.call(5).toString.count)

System.print("Reverse factorials:")
var facts = [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119]
for (fact in facts) Fmt.print("$4s <- rf($d)", rf.call(fact), fact)
