using Primes

function numfactors(n)
    f = [one(n)]
    for (p,e) in factor(n)
        f = reduce(vcat, [f*p^j for j in 1:e], init=f)
    end
    length(f)
end

function A06954(N)
    println("First $N terms of OEIS sequence A069654: ")
    k = 0
    for i in 1:N
        j = k
        while (j += 1) > 0
            if i == numfactors(j)
                print("$j ")
                k = j
                break
            end
        end
    end
end

A06954(15)
