import "/math" for Int
import "/seq" for Lst
import "/fmt" for Fmt
import "/str" for Str

var findFirst = Fn.new { |list|
    var i = 0
    for (n in list) {
        if (n > 1e7)  return [n, i]
        i = i + 1
    }
}

var ranges = [0..0, 101..909, 11011..99099, 1110111..9990999, 111101111..119101111]
var cyclops = []
for (r in ranges) {
    var numDigits = r.from.toString.count
    var center = (numDigits / 2).floor
    for (i in r) {
        var digits = Int.digits(i)
        if (digits[center] == 0 && digits.count { |d| d == 0 } == 1) cyclops.add(i)
    }
}

System.print("The first 50 cyclops numbers are:")
var candidates = cyclops[0...50]
var ni = findFirst.call(cyclops)
for (chunk in Lst.chunks(candidates, 10)) Fmt.print("$,6d", chunk)
Fmt.print("\nFirst such number > 10 million is $,d at zero-based index $,d", ni[0], ni[1])

System.print("\n\nThe first 50 prime cyclops numbers are:")
var primes = cyclops.where { |n| Int.isPrime(n) }
candidates = primes.take(50).toList
ni = findFirst.call(primes)
for (chunk in Lst.chunks(candidates, 10)) Fmt.print("$,6d", chunk)
Fmt.print("\nFirst such number > 10 million is $,d at zero-based index $,d", ni[0], ni[1])

System.print("\n\nThe first 50 blind prime cyclops numbers are:")
var bpcyclops = []
var ppcyclops = []
for (p in primes) {
    var ps = p.toString
    var numDigits = ps.count
    var center = (numDigits/2).floor
    var noMiddle = Num.fromString(Str.delete(ps, center))
    if (Int.isPrime(noMiddle)) bpcyclops.add(p)
    if (ps == ps[-1..0]) ppcyclops.add(p)
}
candidates = bpcyclops[0...50]
ni = findFirst.call(bpcyclops)
for (chunk in Lst.chunks(candidates, 10)) Fmt.print("$,6d", chunk)
Fmt.print("\nFirst such number > 10 million is $,d at zero-based index $,d", ni[0], ni[1])

System.print("\n\nThe first 50 palindromic prime cyclops numbers are:")
candidates = ppcyclops[0...50]
ni = findFirst.call(ppcyclops)
for (chunk in Lst.chunks(candidates, 8)) Fmt.print("$,9d", chunk)
Fmt.print("\nFirst such number > 10 million is $,d at zero-based index $,d", ni[0], ni[1])
