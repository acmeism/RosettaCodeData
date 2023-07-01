import "/math" for Int

for (r in [1..9, 2144..2154, 9987..9999]) {
    for (i in r) {
        var factors = (i > 1) ? Int.primeFactors(i) : [1]
        System.print("%(i): %(factors.join(" x "))")
    }
    System.print()
}
