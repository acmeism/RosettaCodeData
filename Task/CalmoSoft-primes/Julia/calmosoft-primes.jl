using Primes

function calmo_prime_sequence(N)
    pri = primes(N)
    for w in lastindex(pri):-1:2
        psum = sum(pri[1:w])
        for d in 0:lastindex(pri)-w
            if d > 0
                psum -= pri[d]
                psum += pri[w + d]
            end
            if isprime(psum)
                println("Longest Calmo prime seq (length ", w,
                   ") of primes less than $N totals ", sum(pri[begin+d:d+w]))
                if w > 24
                    println(string(pri[d+1:d+6])[begin:end-1], ", ... ",
                       string(pri[d-5+w:d+w])[begin+1:end], "\n")
                else
                    println("The sequence is: ", pri[d+1:d+w], "\n")
                end
                return
            end
        end
    end
end

foreach(calmo_prime_sequence, [100, 500_000, 50_000_000])
