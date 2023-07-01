import "./big" for BigInt
import "./seq" for Lst
import "./fmt" for Fmt

var jacobsthal = Fn.new { |n| ((BigInt.one << n) - ((n%2 == 0) ? 1 : -1)) / 3 }

var jacobsthalLucas = Fn.new { |n| (BigInt.one << n) + ((n%2 == 0) ? 1 : -1) }

System.print("First 30 Jacobsthal numbers:")
var js = (0..29).map { |i| jacobsthal.call(i) }.toList
for (chunk in Lst.chunks(js, 5)) Fmt.print("$,12i", chunk)

System.print("\nFirst 30 Jacobsthal-Lucas numbers:")
var jsl = (0..29).map { |i| jacobsthalLucas.call(i) }.toList
for (chunk in Lst.chunks(jsl, 5)) Fmt.print("$,12i", chunk)

System.print("\nFirst 20 Jacobsthal oblong numbers:")
var oblongs = (0..19).map { |i| js[i] * js[i+1] }.toList
for (chunk in Lst.chunks(oblongs, 5)) Fmt.print("$,14i", chunk)

var primes = js.where { |j| j.isProbablePrime(10) }.toList
var count = primes.count
var i = 31
while (count < 20) {
    var j = jacobsthal.call(i)
    if (j.isProbablePrime(10)) {
        primes.add(j)
        count = count + 1
    }
    i = i + 1
}
System.print("\nFirst 20 Jacobsthal primes:")
for (i in 0..19) Fmt.print("$i", primes[i])
