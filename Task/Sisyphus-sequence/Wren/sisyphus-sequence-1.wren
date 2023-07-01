import "./math" for Int, Nums
import "./fmt" for Fmt

var limit = 1e8
var primes = Int.primeSieve(7 * limit)
var under250 = List.filled(250, 0)
var sisyphus = [1]
under250[1] = 1
var prev = 1
var nextPrimeIndex = 0
var specific = 1000
var count = 1
while (true) {
    var next
    if (prev % 2 == 0) {
        next = prev / 2
    } else {
        next = prev + primes[nextPrimeIndex]
        nextPrimeIndex = nextPrimeIndex + 1
    }
    count = count + 1
    if (count <= 100) sisyphus.add(next)
    if (next < 250) under250[next] = under250[next] + 1
    if (count == 100) {
        System.print("The first 100 members of the Sisyphus sequence are:")
        Fmt.tprint("$3d ", sisyphus, 10)
        System.print()
    } else if (count == specific) {
        var prime = primes[nextPrimeIndex-1]
        Fmt.print("$,13r member is: $,13d and highest prime needed: $,11d", count, next, prime)
        if (count == limit) {
            var notFound = (1..249).where { |i| under250[i] == 0 }.toList
            var max = Nums.max(under250)
            var maxFound = (1..249).where { |i| under250[i] == max }.toList
            Fmt.print("\nThese numbers under 250 do not occur in the first $,d terms:", count)
            Fmt.print("  $n", notFound)
            Fmt.print("\nThese numbers under 250 occur the most in the first $,d terms:", count)
            Fmt.print("  $n all occur $d times.", maxFound, max)
            return
        }
        specific = 10 * specific
    }
    prev = next
}
