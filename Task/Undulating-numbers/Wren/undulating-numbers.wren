import "./fmt" for Fmt, Conv
import "./math" for Int

var undulating = Fn.new { |base, n|
    var mpow = 53
    var limit = 2.pow(mpow) - 1
    var u3 = []
    var u4 = []
    var bsquare = base * base
    for (a in 1...base) {
        for (b in 0...base) {
            if (b == a) continue
            var u = a * bsquare + b * base + a
            u3.add(u)
            var v = a * base + b
            u4.add(v * bsquare + v)
        }
    }
    System.print("All 3 digit undulating numbers in base %(base):")
    Fmt.tprint("$3d ", u3, 9)
    System.print("\nAll 4 digit undulating numbers in base %(base):")
    Fmt.tprint("$4d ", u4, 9)
    System.print("\nAll 3 digit undulating numbers which are primes in base %(base):")
    var primes = []
    for (u in u3) {
        if (u % 2 == 1 && u % 5 != 0 && Int.isPrime(u)) primes.add(u)
    }
    Fmt.tprint("$3d ", primes, 10)
    var un = u3 + u4
    var unc = un.count
    var j = 0
    var done = false
    while (true) {
       for (i in 0...unc) {
           var u = un[j * unc + i] * bsquare + un[j * unc + i] % bsquare
           if (u > limit) {
                done = true
                break
           }
           un.add(u)
       }
       if (done) break
       j = j + 1
    }
    Fmt.print("\nThe $,r undulating number in base $d is: $,d", n, base, un[n-1])
    if (base != 10) Fmt.print("or expressed in base $d : $,s", base, Conv.itoa(un[n-1], base))
    Fmt.print("\nTotal number of undulating numbers in base $d < 2$S = $,d", base, mpow, un.count)
    Fmt.print("of which the largest is: $,d", un[-1])
    if (base != 10) Fmt.print("or expressed in base $d : $,s", base, Conv.itoa(un[-1], base))
    System.print()
}

for (base in [10, 7]) undulating.call(base, 600)
