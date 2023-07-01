using Lazy
using Primes

a(k) = all(m -> !isprime(k + big"2"^m), 1:k-1)

A033939 = @>> Lazy.range(2) filter(isodd) filter(a)

println(take(5, A033939))   # List: (773 2131 2491 4471 5101)
