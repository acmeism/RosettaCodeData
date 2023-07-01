import "/fmt" for Fmt
import "/math" for Int

var binomial = Fn.new { |n, k|
    if (n == k) return 1
    var prod = 1
    var i = n - k + 1
    while (i <= n) {
        prod = prod * i
        i = i + 1
    }
    return prod / Int.factorial(k)
}

var pascalTriangle = Fn.new { |n|
    if (n <= 0) return
    for (i in 0...n) {
        System.write("   " * (n-i-1))
        for (j in 0..i) {
            Fmt.write("$3d   ", binomial.call(i, j))
        }
        System.print()
    }
}

pascalTriangle.call(13)
