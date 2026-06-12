using Primes

function quadrat(N = 16000)
    pmask = primesmask(1, N)
    qprimes, lastn = [2], isqrt(N)
    while (n = qprimes[end]) < N
        for i in 1:lastn
            q = n + i * i
            if  q > N
                return qprimes
            elseif pmask[q]  # got next qprime
                push!(qprimes, q)
                break
            end
        end
    end
end

println("Quadrat special primes < 16000:")
foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(quadrat()))
