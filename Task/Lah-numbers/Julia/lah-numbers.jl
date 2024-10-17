using Combinatorics

function lah(n::Integer, k::Integer, signed=false)
    if n == 0 || k == 0 || k > n
        return zero(n)
    elseif n == k
        return one(n)
    elseif k == 1
        return factorial(n)
    else
        unsignedvalue = binomial(n, k) * binomial(n - 1, k - 1) * factorial(n - k)
        if signed && isodd(n)
            return -unsignedvalue
        else
            return unsignedvalue
        end
    end
end

function printlahtable(kmax)
    println("  ", mapreduce(i -> lpad(i, 12), *, 0:kmax))

    sstring(n, k) = begin i = lah(n, k); lpad(k > n && i == 0 ? "" : i, 12) end

    for n in 0:kmax
        println(rpad(n, 2) * mapreduce(k -> sstring(n, k), *, 0:kmax))
    end
end

printlahtable(12)

println("\nThe maxiumum of lah(100, _) is: ", maximum(k -> lah(BigInt(100), BigInt(k)), 1:100))
