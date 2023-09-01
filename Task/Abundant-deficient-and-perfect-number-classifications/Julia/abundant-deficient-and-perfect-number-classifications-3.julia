using Primes

""" Return tuple of (perfect, abundant, deficient) counts from 1 up to nmax """
function per_abu_def_classify(nmax::Int)
    results = [0, 0, 0]
    for n in 1:nmax
        results[sign(sum(divisors(n)) - 2 * n) + 2] += 1
    end
    return (perfect, abundant, deficient) = results
end

let MAX = 20_000
    NPE, NAB, NDE = per_abu_def_classify(MAX)
    println("$NPE perfect, $NAB abundant, and $NDE deficient numbers in 1:$MAX.")
end
