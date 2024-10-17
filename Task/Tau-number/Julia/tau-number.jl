using Primes

function numfactors(n)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p^j for j in 1:e], init = f)
    end
    length(f)
end

function taunumbers(toget = 100)
    n = 0
    for i in 1:100000000
        if i % numfactors(i) == 0
            n += 1
            print(rpad(i, 5), n % 20 == 0 ? " \n" : "")
            n == toget && break
        end
    end
end

taunumbers()
