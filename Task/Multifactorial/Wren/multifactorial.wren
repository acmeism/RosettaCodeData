import "/fmt" for Fmt

var mf = Fn.new { |n, d|
    var prod = 1
    while (n > 1) {
        prod = prod * n
        n = n - d
    }
    return prod
}

for (d in 1..5) {
    System.write("degree %(d): ")
    for (n in 1..10) System.write(Fmt.d(8, mf.call(n, d)))
    System.print()
}
