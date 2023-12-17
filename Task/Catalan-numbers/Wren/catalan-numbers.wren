import "./fmt" for Fmt
import "./math" for Int

var catalan = Fn.new { |n|
    if (n < 0) Fiber.abort("Argument must be a non-negative integer")
    var prod = 1
    var i = n + 2
    while (i <= n * 2) {
        prod = prod * i
        i = i + 1
    }
    return prod / Int.factorial(n)
}

var catalanRec
catalanRec = Fn.new { |n| (n != 0) ? 2 * (2 * n - 1) * catalanRec.call(n - 1) / (n + 1) : 1 }

System.print(" n  Catalan number")
System.print("------------------")
for (i in 0..15) System.print("%(Fmt.d(2, i))  %(catalan.call(i))")
System.print("\nand again using a recursive function:\n")
for (i in 0..15) System.print("%(Fmt.d(2, i))  %(catalanRec.call(i))")
