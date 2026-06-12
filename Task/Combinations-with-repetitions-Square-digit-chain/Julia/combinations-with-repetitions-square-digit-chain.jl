using Combinatorics

function iterate(m::Integer)
    while m != 1 && m != 89
        s = 0
        while m > 0 # compute sum of squares of digits
            m, d = divrem(m, 10)
            s += d ^ 2
        end
        m = s
    end
    return m
end

function testitersquares(numdigits)
    items =  [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
    onecount, eightyninecount = 0, 0
    for combo in with_replacement_combinations(items, numdigits)
        if any(x -> x != 0, combo)
            pcount = Int(factorial(length(combo)) /
                prod(y -> factorial(sum(x -> x == y, combo)), unique(combo)))
            if iterate(sum(combo)) == 89
                eightyninecount += pcount
            else
                onecount += pcount
            end
        end
    end
    println("For k = $numdigits, in the range 1 to $("9" ^ numdigits),\n" *
        "$onecount numbers produce 1 and $eightyninecount numbers produce 89.\n")
end

for i in [7, 8, 11, 14, 17]
    testitersquares(i)
end
