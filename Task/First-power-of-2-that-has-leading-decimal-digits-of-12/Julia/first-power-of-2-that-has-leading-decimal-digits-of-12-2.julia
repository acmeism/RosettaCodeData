using Formatting, BenchmarkTools

function p(L, n)
    @assert(L > 0 && n > 0)
    Ls, ten18, nfound, i, probe = string(L), 10^18, 0, 0, 1
    maxdigits = 10^(18 - ndigits(L))
    while true
        probe += probe
        i += 1
        if probe >= ten18
            while true
                (probe >= ten18) && (probe ÷= 10)
                if probe ÷ maxdigits == L
                    if (nfound += 1) >= n
                        nfound -= 1
                        break
                    end
                end
                probe += probe
                i += 1
            end
        end
        ps = string(probe)
        len = min(length(Ls), length(ps))
        if ps[1:len] == Ls && (nfound += 1) >= n
            break
        end
    end
    return i
end

function testpLn(verbose)
    for (L, n) in [(12, 1), (12, 2), (123, 45), (123, 12345), (123, 678910)]
        i = p(L, n)
        verbose && println("With L = $L and n = $n, p(L, n) = ", format(i, commas=true))
    end
end

testpLn(true)
@btime testpLn(false)
