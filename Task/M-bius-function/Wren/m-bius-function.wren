import "./fmt" for Fmt
import "./math" for Int

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

System.print("The first 199 Möbius numbers are:")
for (i in 0..9) {
    for (j in 0..19) {
        if (i == 0 && j == 0) {
            System.write("    ")
        } else {
            Fmt.write("$ 3d ", mu.call(i*20 + j))
        }
    }
    System.print()
}
