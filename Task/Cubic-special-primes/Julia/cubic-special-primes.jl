using Primes

function cubicspecialprimes(N = 15000)
    pmask = primesmask(1, N)
    cprimes, maxidx = [2], isqrt(N)
    while (n = cprimes[end]) < N
        for i in 1:maxidx
            q = n + i * i * i
            if  q > N
                return cprimes
            elseif pmask[q]  # got next qprime
                push!(cprimes, q)
                break
            end
        end
    end
end

println("Cubic special primes < 15000:")
foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(cubicspecialprimes()))
