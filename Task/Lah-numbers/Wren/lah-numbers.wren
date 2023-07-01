import "/fmt" for Fmt

var fact = Fn.new  { |n|
    if (n < 2) return 1
    var fact = 1
    for (i in 2..n) fact = fact * i
    return fact
}

var lah = Fn.new { |n, k|
    if (k == 1) return fact.call(n)
    if (k == n) return 1
    if (k > n) return 0
    if (k < 1 || n < 1) return 0
    return (fact.call(n) * fact.call(n-1)) / (fact.call(k) * fact.call(k-1)) / fact.call(n-k)
}

System.print("Unsigned Lah numbers: l(n, k):")
System.write("n/k")
for (i in 0..12) System.write("%(Fmt.d(10, i)) ")
System.print("\n" + "-" * 145)
for (n in 0..12) {
    System.write("%(Fmt.d(2, n)) ")
    for (k in 0..n) System.write("%(Fmt.d(10, lah.call(n, k))) ")
    System.print()
}
