using Combinatorics
using Primes

function ascendingprimes()
    return filter(isprime, [evalpoly(10, reverse(x))
       for x in powerset([1, 2, 3, 4, 5, 6, 7, 8, 9]) if !isempty(x)])
end

foreach(p -> print(rpad(p[2], 10), p[1] % 10 == 0 ? "\n" : ""), enumerate(ascendingprimes()))

@time ascendingprimes()
