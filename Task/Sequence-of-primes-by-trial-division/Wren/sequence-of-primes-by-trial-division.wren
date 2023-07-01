import "/fmt" for Fmt

var primeSeq = Fiber.new {
    Fiber.yield(2)
    var n = 3
    while (true) {
        var isPrime = true
        var p = 3
        while (p * p <= n) {
            if (n%p == 0) {
                isPrime = false
                break
            }
            p =  p + 2
        }
        if (isPrime) Fiber.yield(n)
        n = n + 2
    }
}

var limit = 315
var count = 0
while (true) {
    var p = primeSeq.call()
    System.write("%(Fmt.d(4, p)) ")
    count = count + 1
    if (count%15 == 0) System.print()
    if (count == limit) break
}
