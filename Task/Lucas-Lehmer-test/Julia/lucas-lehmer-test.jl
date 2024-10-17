using Primes

function getmersenneprimes(n)
    t1 = time()
    count = 0
    i = 2
    while(n > count)
        if(isprime(i) && ismersenneprime(2^BigInt(i) - 1))
            println("M$i, cumulative time elapsed: $(time() - t1) seconds")
            count += 1
        end
        i += 1
    end
end

getmersenneprimes(50)
