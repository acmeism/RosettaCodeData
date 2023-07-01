import "/math" for Int
import "/iterate" for Stepped
import "/fmt" for Fmt
import "/rat" for Rat

var f //recursive
f = Fn.new { |l, r, n|
    var m = Rat.new(l.num + r.num, l.den + r.den)
    if (m.den <= n) {
        f.call(l, m, n)
        System.write("%(m) ")
        f.call(m, r, n)
    }
}

/* Task 1: solution by recursive generation of mediants. */
for (n in 1..11) {
    var l = Rat.zero
    var r = Rat.one
    System.write("F(%(n)): %(l) ")
    f.call(l, r, n)
    System.print(r)
}
System.print()

/* Task 2: direct solution by summing totient function. */

// generate primes to 1000
var comp = Int.primeSieve(1001, false)

// generate totients to 1000
var tot = List.filled(1001, 1)
for (n in 2..1000) {
    if (!comp[n]) {
        tot[n] = n - 1
        for (a in Stepped.ascend(n*2..1000, n)) {
            var f = n - 1
            var r = (a/n).floor
            while (r%n == 0) {
                f = f * n
                r = (r/n).floor
            }
            tot[a] = tot[a] * f
        }
    }
}

// sum totients
var sum = 1
for (n in 1..1000) {
    sum = sum + tot[n]
    if (n%100 == 0) System.print("F(%(Fmt.d(4, n))): %(Fmt.dc(7, sum))")
}
