""" modified from https://codegolf.stackexchange.com/questions/230509/find-the-erd%C5%91s-woods-origin/ """

using BitIntegers

"""
Returns the smallest value for `a` of Erdős-Woods number n, -1 if n is not in sequence
"""
function erdős_woods(n)
    primes = Int[]
    P = BigInt(1)
    k = 1
    while k < n
        P % k != 0 && push!(primes, k)
        P *= k * k
        k += 1
    end
    divs = [evalpoly(2, [Int(a % p == 0) for p in primes]) for a in 0:n-1]
    np = length(primes)
    partitions = [(Int256(0), Int256(0), Int256(2)^np - 1)]
    ort(x) = trailing_zeros(divs[x + 1] | divs[n - x + 1])
    for i in sort(collect(1:n-1), lt = (b, c) -> ort(b) > ort(c))
        new_partitions = Tuple{Int256, Int256, Int256}[]
        factors = divs[i + 1]
        other_factors = divs[n - i + 1]
        for p in partitions
            set_a, set_b, r_primes = p
            if (factors & set_a != 0) || (other_factors & set_b != 0)
                push!(new_partitions, p)
                continue
            end
            for (ix, v) in enumerate(reverse(string(factors & r_primes, base=2)))
                if v == '1'
                    w = Int256(1) << (ix - 1)
                    push!(new_partitions, (set_a ⊻ w, set_b, r_primes ⊻ w))
                end
            end
            for (ix, v) in enumerate(reverse(string(other_factors & r_primes, base=2)))
                if v == '1'
                    w = Int256(1) << (ix - 1)
                    push!(new_partitions, (set_a, set_b ⊻ w, r_primes ⊻ w))
                end
            end
        end
        partitions = new_partitions
    end
    result = Int256(-1)
    for (px, py, _) in partitions
        x, y = Int256(1), Int256(1)
        for p in primes
            isodd(px) && (x *= p)
            isodd(py) && (y *= p)
            px ÷= 2
            py ÷= 2
        end
        newresult = ((n * invmod(x, y)) % y) * x - n
        result = result == -1 ? newresult : min(result, newresult)
    end
    return result
end

function test_erdős_woods(startval=3, endval=116)
    arr = fill((0, Int256(-1)), endval - startval + 1)
    @Threads.threads for k in startval:endval
        arr[k - startval + 1] = (k, erdős_woods(k))
    end
    ewvalues = filter(x -> last(x) > 0, arr)
    println("The first $(length(ewvalues)) Erdős–Woods numbers and their minimum interval start values are:")
    for (k, a) in ewvalues
        println(lpad(k, 3), " -> $a")
    end
end

test_erdős_woods()
