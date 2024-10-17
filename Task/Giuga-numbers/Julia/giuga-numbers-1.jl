using Primes

isGiuga(n) = all(f -> f != n && rem(n ÷ f - 1, f) == 0, factor(Vector, n))

function getGiuga(N)
    gcount = 0
    for i in 4:typemax(Int)
        if isGiuga(i)
            println(i)
            (gcount += 1) >= N && break
        end
    end
end

getGiuga(4)
