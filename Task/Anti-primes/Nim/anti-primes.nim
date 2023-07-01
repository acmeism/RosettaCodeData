# First 20 antiprimes

proc countDivisors(n: int): int =
    if n < 2:
        return 1
    var count = 2
    for i in countup(2, (n / 2).toInt()):
        if n %% i == 0:
            count += 1
    return count

proc antiPrimes(n: int) =
    echo("The first ", n, " anti-primes:")
    var maxDiv = 0
    var count = 0
    var i = 1
    while count < n:
        let d = countDivisors(i)
        if d > maxDiv:
            echo(i)
            maxDiv = d
            count += 1
        i += 1

antiPrimes(20)
