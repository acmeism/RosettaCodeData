using Primes

""" proper divisors of n """
function proper_divisors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    pop!(f)
    return f
end

""" return true if any subset of f sums to n. """
function sumofanysubset(n, f)
    n in f && return true
    total = sum(f)
    n == total && return true
    n > total && return false
    rf = reverse(f)
    d = n - popfirst!(rf)
    return (d in rf) || (d > 0 && sumofanysubset(d, rf)) || sumofanysubset(n, rf)
end

function ispractical(n)
    n == 1 && return true
    isodd(n) && return false
    f = proper_divisors(n)
    return all(i -> sumofanysubset(i, f), 1:n-1)
end

const prac333 = filter(ispractical, 1:333)
println("There are ", length(prac333), " practical numbers between 1 to 333 inclusive.")
println("Start and end: ", filter(x -> x < 25, prac333), " ... ", filter(x -> x > 287, prac333), "\n")
for n in [666, 6666, 66666, 222222]
    println("$n is ", ispractical(n) ? "" : "not ", "a practical number.")
end
