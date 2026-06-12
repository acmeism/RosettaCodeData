using Primes, Formatting

function sum25(p::String, rm, res)
    if rm == 0
        if p[end] in "1379" && isprime(parse(Int128, p))
            res += 1
        end
    else
        for i in 1:min(rm, 9)
            res = sum25(p * string(i), rm - i, res)
        end
    end
    return res
end

@time println("There are ", format(sum25("", 25, 0), commas=true),
    " primes whose digits sum to 25 without any zero digits.")
