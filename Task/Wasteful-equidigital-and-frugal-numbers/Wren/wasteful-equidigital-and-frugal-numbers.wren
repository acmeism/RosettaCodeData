import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var analyze = Fn.new { |n, b|
    var factors = Int.primeFactors(n)
    var indivs = Lst.individuals(factors)
    var digits = 0
    for (indiv in indivs) {
        digits = digits + Int.digits(indiv[0], b).count
        if (indiv[1] > 1) digits = digits + Int.digits(indiv[1], b).count
    }
    return [Int.digits(n, b).count, digits]
}

for (b in [10, 11]) {
    var w = []
    var e = [1]
    var f = []
    var wc = 0
    var ec = 1
    var fc = 0
    var wc2 = 0
    var ec2 = 1
    var fc2 = 0
    var n = 2
    System.print("FOR BASE %(b):\n")
    while (fc < 10000 || ec < 10000 || wc < 10000) {
        var r = analyze.call(n, b)
        if (r[0] < r[1]) {
            if (w.count < 50 || wc == 9999) w.add(n)
            wc = wc + 1
            if (n < 1e6) wc2 = wc2 + 1
        } else if (r[0] == r[1]) {
            if (e.count < 50 || ec == 9999) e.add(n)
            ec = ec + 1
            if (n < 1e6) ec2 = ec2 + 1
        } else {
            if (f.count < 50 || fc == 9999) f.add(n)
            fc = fc + 1
            if (n < 1e6) fc2 = fc2 + 1
        }
        n = n + 1
    }
    System.print("First 50 Wasteful numbers:")
    Fmt.tprint("$4d", w[0..49], 10)
    System.print()
    System.print("First 50 Equidigital numbers:")
    Fmt.tprint("$4d", e[0..49], 10)
    System.print()
    System.print("First 50 Frugal numbers:")
    Fmt.tprint("$4d", f[0..49], 10)
    System.print()
    System.print("10,000th Wasteful number    : %(w[50])")
    System.print("10,000th Equidigital number : %(e[50])")
    System.print("10,000th Frugal number      : %(f[50])")
    System.print()
    System.print("For natural numbers < 1 million, the breakdown is as follows:")
    Fmt.print("  Wasteful numbers    : $6d", wc2)
    Fmt.print("  Equidigital numbers : $6d", ec2)
    Fmt.print("  Frugal numbers      : $6d", fc2)
    System.print()
}
