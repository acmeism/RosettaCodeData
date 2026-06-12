import "./ioutil" for Input
import "./seq" for Lst
import "./perm" for Powerset, Comb
import "./math" for Int

while (true) {
    var test = Input.text("Please enter a string of letters or q to quit: ", 1)
    if (test == "q") return
    test = test.toList
    var fib = Fiber.new { |a| Powerset.generate(a) }
    var count = 0
    while (true) {
        var s = fib.call(test)
        if (!s || s.count > 4) break
        if (s.count < 2)  continue
        var allPrime = true
        for (pair in Comb.list(s, 2)) {
            var delta = (pair[0].codePoints[0] - pair[1].codePoints[0]).abs
            if (!Int.isPrime(delta)) {
                allPrime = false
                break
            }
        }
        if (allPrime) count = count + 1
    }
    System.print(count)
    System.print()
}
