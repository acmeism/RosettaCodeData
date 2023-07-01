import strformat

func totient(n: int): int =
    var tot = n
    var nn = n
    var i = 2
    while i * i <= nn:
        if nn mod i == 0:
            while nn mod i == 0:
                nn = nn div i
            dec tot, tot div i
        if i == 2:
            i = 1
        inc i, 2
    if nn > 1:
        dec tot, tot div nn
    tot

echo " n    φ   prime"
echo "---------------"
var count = 0
for n in 1..25:
    let tot = totient(n)
    let isPrime = n - 1 == tot
    if isPrime:
        inc count
    echo fmt"{n:2}   {tot:2}   {isPrime}"
echo ""
echo fmt"Number of primes up to {25:>6} = {count:>4}"
for n in 26..100_000:
    let tot = totient(n)
    if tot == n - 1:
        inc count
    if n == 100 or n == 1000 or n mod 10_000 == 0:
        echo fmt"Number of primes up to {n:>6} = {count:>4}"
