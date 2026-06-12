function equal_digitalsum_exponents(n::Integer)
    equalpows = Int[]
    if n > 1
        npow, misses = 2, 0
        while misses < n + 50
            dsum = sum(digits(BigInt(n) ^ npow))
            if npow > 10 && dsum > 2 * n
                break # bail here for time contraints (see Wren example)
            elseif dsum == n
                push!(equalpows, npow)
            else
                misses += 1
            end
            npow += 1
        end
    end
    return equalpows
end

function testdigitalequals(lim, wanted, multiswanted)
    found1, found2, multis = 0, 0, Tuple{Int, Vector{Int}}[]
    println("First $wanted integers that are equal to the digital sum of that integer raised to some power:")
    for i in 1:lim
        a = equal_digitalsum_exponents(i)
        if !isempty(a)
            found1 += 1
            if found1 <= wanted
                print(rpad(i, 6), found1 % 10 == 0 ? "\n" : "")
            end
            if length(a) > 2
                found2 += 1
                push!(multis, (i, a))
                if found2 == multiswanted
                    println("\nFirst $multiswanted that satisfy that condition in three or more ways:")
                    for (n, v) in multis
                        println("$n: powers $v")
                    end
                end
                found1 >= wanted && found2 >= multiswanted && break
            end
        end
    end
end

testdigitalequals(6000, 25, 30)
