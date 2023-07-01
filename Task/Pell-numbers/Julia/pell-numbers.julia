using Primes

function pellnumbers(wanted)
    pells = [0, 1]
    wanted < 3 && return pells[1:wanted]
    while length(pells) < wanted
        push!(pells, 2 * pells[end] + pells[end - 1])
    end
    return pells
end

function pelllucasnumbers(wanted)
    pelllucas = [2, 2]
    wanted < 3 && return pelllucas[1:wanted]
    while length(pelllucas) < wanted
        push!(pelllucas, 2 * pelllucas[end] + pelllucas[end - 1])
    end
    return pelllucas
end

function pellprimes(wanted)
    i, lastpell, lastlastpell, primeindices, pellprimes = 1, big"1", big"0", Int[], BigInt[]
    while length(primeindices) < wanted
        pell = 2 * lastpell + lastlastpell
        i += 1
        if isprime(pell)
            push!(primeindices, i)
            push!(pellprimes, pell)
        end
        lastpell, lastlastpell = pell, lastpell
    end
    return primeindices, pellprimes
end

function approximationsqrt2(wanted)
    p, q = pellnumbers(wanted + 1), pelllucasnumbers(wanted + 1)
    return map(r -> "$r ≈ $(Float64(r))", [(q[n] // 2) // p[n] for n in 2:wanted+1])
end

function newmanshankwilliams(wanted)
    pells = pellnumbers(wanted * 2 + 1)
    return [pells[2i - 1] + pells[2i] for i in 1:wanted]
end

function nearisosceles(wanted)
    pells = pellnumbers((wanted + 1) * 2 + 1)
    return map(x -> (last(x), last(x) + 1, first(x)),
       [(pells[2i], sum(pells[1:2i-1])) for i in 2:wanted+1])
end

function printrows(title, vec, columnsize = 8, columns = 10, rjust=false)
    println(title)
    for (i, n) in enumerate(vec)
        print((rjust ? lpad : rpad)(n, columnsize), i % columns == 0 ? "\n" : "")
    end
    println()
end

printrows("Twenty Pell numbers:", pellnumbers(20))
printrows("Twenty Pell-Lucas numbers:", pelllucasnumbers(20))
printrows("Twenty approximations of √2:", approximationsqrt2(20), 44, 2)
pindices, pprimes = pellprimes(15)
printrows("Fifteen Pell primes:", pprimes, 90, 1)
printrows("Fifteen Pell prime zero-based indices:", pindices, 4, 15)
printrows("Twenty Newman-Shank-Williams numbers:", newmanshankwilliams(20), 17, 5)
printrows("Twenty near isosceles triangle triplets:", nearisosceles(20), 52, 2)
