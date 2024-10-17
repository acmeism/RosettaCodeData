using Primes

function propfact(n)
    f = [one(n)]
    for (p, x) in factor(n)
        f = reduce(vcat, [f*p^i for i in 1:x], init=f)
    end
    pop!(f)
    sort(f)
end

isabundant(n) = sum(propfact(n)) > n
prettyprintfactors(n) = (a = propfact(n); println("$n has proper divisors $a, these sum to $(sum(a))."))

function oddabundantsfrom(startingint, needed, nprint=0)
    n = isodd(startingint) ? startingint : startingint + 1
    count = one(n)
    while count <= needed
        if isabundant(n)
            if nprint == 0
                prettyprintfactors(n)
            elseif nprint == count
                prettyprintfactors(n)
            end
            count += 1
        end
        n += 2
    end
end

println("First 25 abundant odd numbers:")
oddabundantsfrom(2, 25)

println("The thousandth abundant odd number:")
oddabundantsfrom(2, 1001, 1000)

println("The first abundant odd number greater than one billion:")
oddabundantsfrom(1000000000, 1)
