// version 1.0.6

fun isPerfect(n: Int): Boolean = when {
        n < 2      -> false
        n % 2 == 1 -> false  // there are no known odd perfect numbers
        else       -> {
            var tot = 1
            var q: Int
            for (i in 2 .. Math.sqrt(n.toDouble()).toInt()) {
                if (n % i == 0) {
                    tot += i
                    q = n / i
                    if (q > i) tot += q
                }
            }
            n == tot
        }
    }

fun main(args: Array<String>) {
    // expect a run time of about 6 minutes on a typical laptop
    println("The first five perfect numbers are:")
    for (i in 2 .. 33550336) if (isPerfect(i)) print("$i ")
}
