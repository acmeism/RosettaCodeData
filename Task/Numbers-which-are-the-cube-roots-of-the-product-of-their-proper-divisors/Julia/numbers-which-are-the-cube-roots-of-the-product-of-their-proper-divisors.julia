using Printf

function proper_divisors(n::Integer)
    uptosqr = 1:isqrt(n)
    divs = Iterators.filter(uptosqr) do m
        n % m == 0
    end
    pd_pairs = Iterators.map(divs) do d1
        d2 = div(n, d1)
        (d1 == d2 || d1 == 1) ? (d1,) : (d1, d2)
    end
    return Iterators.flatten(pd_pairs)
end

function show_divisors_print(n::Integer, found::Integer)
    if found <= 50
        @printf "%5i" n
        if found % 10 == 0
            println()
        end
    elseif found in (500, 5_000, 50_000)
        th = "$(found)th: "
        @printf "%10s%i\n" th n
    end
end

function show_divisors()
    found = 0
    n = 1
    while found <= 50_000
        pds = proper_divisors(n)
        if n^3 == prod(pds)
            found += 1
            show_divisors_print(n, found)
        end
        n += 1
    end
end

show_divisors()
