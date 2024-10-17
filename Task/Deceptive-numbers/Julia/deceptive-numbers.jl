using Primes

function deceptives(numwanted)
    n, r, ret = 2, big"1", Int[]
    while length(ret) < numwanted
        !isprime(n) && r % n == 0 && push!(ret, n)
        n += 1
        r = 10r + 1
    end
    return ret
end

@time println(deceptives(30))
