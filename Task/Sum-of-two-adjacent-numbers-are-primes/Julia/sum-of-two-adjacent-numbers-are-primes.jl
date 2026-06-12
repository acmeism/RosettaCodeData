using Lazy
using Primes

seq = @>> Lazy.range() filter(n -> isprime(2n + 1))
for n in take(20, seq)
    println("$n + $(n + 1) = $(n + n + 1)")
end

let
    i, cnt = 0, 0
    while cnt < 10_000_000
        i += 1
        if isprime(2i + 1)
            cnt += 1
        end
    end
    println("Ten millionth: $i + $(i + 1) = $(i + i + 1)")
end
