using Primes

function nsmooth(N, needed)
    nexts, smooths = [BigInt(i) for i in 2:N if isprime(i)], [BigInt(1)]
    prim, count = deepcopy(nexts), 1
    indices = ones(Int, length(nexts))
    while count < needed
        x = minimum(nexts)
        push!(smooths, x)
        count += 1
        for j in 1:length(nexts)
            (nexts[j] <= x) && (nexts[j] = prim[j] * smooths[(indices[j] += 1)])
        end
    end
    return (smooths[end] > typemax(Int)) ? smooths : Int.(smooths)
end

function testnsmoothfilters()
    for i in filter(isprime, 1:29)
        println("The first 25 n-smooth numbers for n = $i are: ", nsmooth(i, 25))
    end
    for i in filter(isprime, 3:29)
        println("The 3000th through 3002nd ($i)-smooth numbers are: ", nsmooth(i, 3002)[3000:3002])
    end
    for i in filter(isprime, 503:521)
        println("The 30000th through 30019th ($i)-smooth numbers >= 30000 are: ", nsmooth(i, 30019)[30000:30019])
    end
end

testnsmoothfilters()
