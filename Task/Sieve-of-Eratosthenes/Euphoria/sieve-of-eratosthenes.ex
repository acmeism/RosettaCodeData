constant limit = 1000
sequence flags,primes
flags = repeat(1, limit)
for i = 2 to sqrt(limit) do
    if flags[i] then
        for k = i*i to limit by i do
            flags[k] = 0
        end for
    end if
end for

primes = {}
for i = 2 to limit do
    if flags[i] = 1 then
        primes &= i
    end if
end for
? primes
