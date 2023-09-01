// Iterative

func gcd(a: Int, b: Int) -> Int {

    var a = abs(a)
    var b = abs(b)

    if (b > a) { swap(&a, &b) }

    while (b > 0) { (a, b) = (b, a % b) }

    return a
}

// Recursive

func gcdr (a: Int, b: Int) -> Int {

    var a = abs(a)
    var b = abs(b)

    if (b > a) { swap(&a, &b) }

    return gcd_rec(a,b)
}


private func gcd_rec(a: Int, b: Int) -> Int {

    return b == 0 ? a : gcd_rec(b, a % b)
}


for (a,b) in [(1,1), (100, -10), (10, -100), (-36, -17), (27, 18), (30, -42)] {

    println("Iterative: GCD of \(a) and \(b) is \(gcd(a, b))")
    println("Recursive: GCD of \(a) and \(b) is \(gcdr(a, b))")
}
