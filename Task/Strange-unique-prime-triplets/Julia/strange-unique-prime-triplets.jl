using Primes

function prime_sum_prime_triplets_to(N, verbose=false)
    a = primes(3, N)
    prime_sieve_set = primesmask(1, N * 3)
    len, triplets, n = length(a), Dict{Tuple{Int64,Int64,Int64}, Int}(), 0
    for i in eachindex(a), j in i+1:len, k in j+1:len
        if prime_sieve_set[a[i] + a[j] + a[k]]
            verbose && (triplets[(a[i], a[j], a[k])] = 1)
            n += 1
        end
    end
    if verbose
        len = (length(string(N)) + 2) * 3
        println("\n", rpad("Triplet", len), "Sum\n", "-"^(len+3))
        for k in sort(collect(keys(triplets)), lt = (x, y) -> collect(x) < collect(y))
            println(rpad(k, len), sum(k))
        end
    end
    println("\n\n$n unique triplets of 3 primes between 2 and $N sum to a prime.")
    return triplets
end

prime_sum_prime_triplets_to(30, true)
prime_sum_prime_triplets_to(1000)
@time prime_sum_prime_triplets_to(10000)
@time prime_sum_prime_triplets_to(100000)
