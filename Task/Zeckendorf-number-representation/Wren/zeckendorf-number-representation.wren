import "./fmt" for Fmt

var LIMIT = 46  // to stay within range of signed 32 bit integer

var fibonacci = Fn.new { |n|
    if (n < 2 || n > LIMIT) Fiber.abort("n must be between 2 and %(LIMIT)")
    var fibs = List.filled(n, 1)
    for (i in 2...n) fibs[i] = fibs[i - 1] + fibs[i - 2]
    return fibs
}

var fibs = fibonacci.call(LIMIT)

var zeckendorf = Fn.new { |n|
    if (n < 0) Fiber.abort("n must be non-negative")
    if (n < 2) return n.toString
    var lastFibIndex = 1
    for (i in 2..LIMIT) {
        if (fibs[i] > n) {
            lastFibIndex = i - 1
            break
        }
    }
    n = n - fibs[lastFibIndex]
    lastFibIndex = lastFibIndex - 1
    var zr = "1"
    for (i in lastFibIndex..1) {
        if (fibs[i] <= n) {
            zr = zr + "1"
            n = n - fibs[i]
        } else {
            zr = zr + "0"
        }
    }
    return zr
}

System.print(" n   z")
for (i in 0..20) Fmt.print("$2d : $s", i, zeckendorf.call(i))
