using Primes
using Printf

function printdt(N)
    @printf("Double twin primes under 1,000:\n")
    for i in 3:2:N-8
        if isprime(i) && isprime(i+2) && isprime(i+6) && isprime(i+8)
            @printf("%4d %4d %4d %4d\n", i, i+2, i+6, i+8)
        end
    end
end

printdt(1000)
