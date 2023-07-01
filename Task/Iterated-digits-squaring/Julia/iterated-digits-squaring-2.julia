using Combinatorics
function itercountcombos(ndigits::Integer)
    cnt = 0
    f = factorial(ndigits)
    # loop over all combinations of ndigits decimal digits:
    for comb in combinations(1:(10+ndigits-1), ndigits)
        s = 0
        perms = 1
        prevd = -1
        rep = 1
        for k = eachindex(comb) # sum digits ^ 2 and count permutations
            d = comb[k] - k
            s += d ^ 2
            # accumulate number of permutations of repeated digits
            if d == prevd
                rep += 1
                perms *= rep
            else
                prevd = d
                rep = 1
            end
        end
        if s > 0 && iterate(s) == 89
            cnt += f ÷ perms # numbers we can get from digits
        end
    end
    return cnt
end
