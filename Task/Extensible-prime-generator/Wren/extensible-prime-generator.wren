import "/fmt" for Fmt

var primeSieve = Fn.new { |limit|
    if (limit < 2) return []
    var c = [false] * (limit + 1) // composite = true
    c[0] = true
    c[1] = true
    // no need to process the even numbers > 2
    var k = 9
    while (k <= limit) {
        c[k] = true
        k = k + 6
    }
    k = 25
    while (k <= limit) {
        c[k] = true
        k = k + 10
    }
    k = 49
    while (k <= limit) {
        c[k] = true
        k = k + 14
    }
    var p = 11
    var p2 = 121
    var inc = [2,4,2,4,6,2,6,4,2,4,6,6,2,6,4,2,6,4,6,8,4,2,4,2,
        4,8,6,4,6,2,4,6,2,6,6,4,2,4,6,2,6,4,2,4,2,10,2,10]
    var w = 0
    while (p2 <= limit) {
        var i = p2
        while (i <= limit) {
            c[i] = true
            i = i + 2*p
        }
        var ok = true
        while (ok) {
            p = p + inc[w]
            w = (w + 1) % 48
            ok = c[p]
        }
        p2 = p * p
    }
    var primes = [2]
    var i = 3
    while (i <= limit) {
        if (!c[i]) primes.add(i)
        i = i + 2
    }
    return primes
}

var primes = primeSieve.call(1e8 * 2)
System.print("The first 20 primes are: ")
System.print(primes.take(20).toList)
System.print("\nThe primes between 100 and 150 are:")
System.print(primes.where { |p| p > 100 && p < 150 }.toList)
System.write("\nThe number of primes between 7,700 and 8,000 is: ")
Fmt.print("$,d", primes.count{ |p| p > 7700 && p < 8000 })
Fmt.print("\nThe 10,000th prime is: $,d",  primes[9999])
Fmt.print("\nThe 100,000th prime is: $,d", primes[99999])
Fmt.print("\nThe 1,000,000th prime is: $,d", primes[999999])
