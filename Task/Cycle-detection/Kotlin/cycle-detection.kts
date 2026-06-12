// version 1.1.2

typealias IntToInt = (Int) -> Int

fun brent(f: IntToInt, x0: Int): Pair<Int, Int> {
    // main phase: search successive powers of two
    var power = 1
    var lam = 1
    var tortoise = x0
    var hare = f(x0)  // f(x0) is the element/node next to x0.
    while (tortoise != hare) {
        if (power == lam) {  // time to start a new power of two?
            tortoise = hare
            power *= 2
            lam = 0
        }
        hare = f(hare)
        lam++
    }

    // Find the position of the first repetition of length 'lam'
    var mu = 0
    tortoise = x0
    hare = x0
    for (i in 0 until lam) hare = f(hare)

    // The distance between the hare and tortoise is now 'lam'.
    // Next, the hare and tortoise move at same speed until they agree
    while (tortoise != hare) {
        tortoise = f(tortoise)
        hare = f(hare)
        mu++
    }
    return Pair(lam, mu)
}

fun main(args: Array<String>) {
    val f = { x: Int -> (x * x + 1) % 255 }
    // generate first 41 terms of the sequence starting from 3
    val x0 = 3
    var x = x0
    val seq = List(41) { if (it > 0) x = f(x) ; x }
    println(seq)
    val (lam, mu) = brent(f, x0)
    val cycle = seq.slice(mu until mu + lam)
    println("Cycle length = $lam")
    println("Start index  = $mu")
    println("Cycle        = $cycle")
}
