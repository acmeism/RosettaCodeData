//  version 1.0.5-2

fun isPrime(n: Int) : Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d : Int = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun main(args: Array<String>) {
    var j: Char
    var p: Int
    var pow: Int
    var lMax: Int = 2
    var rMax: Int = 2
    var s: String

    // calculate maximum left truncatable prime less than 1 million
    loop@ for( i in 3..999997 step 2) {
        s = i.toString()
        if ('0' in s) continue
        j = s[s.length - 1]
        if (j == '1' || j == '9') continue
        p = i
        pow = 1
        for (k in 1..s.length - 1) pow *= 10
        while(pow > 1) {
            if (!isPrime(p)) continue@loop
            p %= pow
            pow /= 10
        }
        lMax = i
    }

    // calculate maximum right truncatable prime less than 1 million
    loop@ for( i in 3..799999 step 2) {
        s = i.toString()
        if ('0' in s) continue
        j = s[0]
        if (j == '1' || j == '4' || j == '6') continue
        p = i
        while(p > 0) {
            if (!isPrime(p)) continue@loop
            p /= 10
        }
        rMax = i
    }

    println("Largest left  truncatable prime : " + lMax.toString())
    println("Largest right truncatable prime : " + rMax.toString())
}
