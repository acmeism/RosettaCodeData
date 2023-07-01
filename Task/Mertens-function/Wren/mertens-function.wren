import "/fmt" for Fmt
import "/math" for Int

var isSquareFree = Fn.new { |n|
    var i = 2
    while (i * i <= n) {
        if (n%(i*i) == 0) return false
        i = (i > 2) ? i + 2 : i + 1
    }
    return true
}

var mu = Fn.new { |n|
    if (n < 1) Fiber.abort("Argument must be a positive integer")
    if (n == 1) return 1
    var sqFree = isSquareFree.call(n)
    var factors = Int.primeFactors(n)
    if (sqFree && factors.count % 2 == 0) return 1
    if (sqFree) return -1
    return 0
}

var M = Fn.new { |x| (1..x).reduce { |sum, n| sum + mu.call(n) } }

System.print("The first 199 Mertens numbers are:")
for (i in 0..9) {
    for (j in 0..19) {
        if (i == 0 && j == 0) {
            System.write("    ")
        } else {
            System.write("%(Fmt.dm(3, M.call(i*20 + j))) ")
        }
    }
    System.print()
}

// use the recurrence relationship for the last 2 parts rather than calling M directly
var count = 0
var mertens = M.call(1)
for (i in 2..1000) {
    mertens = mertens + mu.call(i)
    if (mertens == 0) count = count + 1
}
System.print("\nThe Mertens function is zero %(count) times in the range [1, 1000].")

count = 0
var prev = M.call(1)
for (i in 2..1000) {
    var next = prev + mu.call(i)
    if (next == 0 && prev != 0) count = count + 1
    prev = next
}
System.print("\nThe Mertens function crosses zero %(count) times in the range [1, 1000].")
