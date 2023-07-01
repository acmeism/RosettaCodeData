using Primes

function primepi(N)
    delta = round(Int, N^0.8)
    return sum(i -> count(primesmask(i, min(i + delta - 1, N))), 1:delta:N)
end

@time for power in 0:9
    println("10^", rpad(power, 5), primepi(10^power))
end
