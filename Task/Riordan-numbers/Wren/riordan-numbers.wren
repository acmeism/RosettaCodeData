import "./gmp" for Mpz
import "./fmt" for Fmt

var limit = 10000
var a = List.filled(limit, null)
a[0] = Mpz.one
a[1] = Mpz.zero
for (n in 2...limit) {
    a[n] = (a[n-1] * 2 + a[n-2] * 3) * (n-1) / (n+1)
}
System.print("First 32 Riordan numbers:")
Fmt.tprint("$,17i", a[0..31], 4)
System.print()
for (i in [1e3, 1e4]) {
   Fmt.print("$,8r: $20a ($,d digits)", i, a[i-1], a[i-1].toString.count)
}
