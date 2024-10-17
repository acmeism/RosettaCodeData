function counthumbledigits(maxdigits, returnsequencelength=50)
    n, count, adjustindex, maxdiff = BigInt(1), 0, BigInt(0), 0
    humble, savesequence = Vector{BigInt}([1]), Vector{BigInt}()
    base2, base3, base5, base7 = 1, 1, 1, 1
    next2, next3, next5, next7 = BigInt(2), BigInt(3), BigInt(5), BigInt(7)
    digitcounts= Dict{Int, Int}(1 => 1)
    while n < BigInt(10)^(maxdigits+1)
        n = min(next2, next3, next5, next7)
        push!(humble, n)
        count += 1
        if count == returnsequencelength
            savesequence = deepcopy(humble[1:returnsequencelength])
        elseif count > 2000000
            popfirst!(humble)
            adjustindex += 1
        end
        placesbase10 = length(string(n))
        if haskey(digitcounts, placesbase10)
            digitcounts[placesbase10] += 1
        else
            digitcounts[placesbase10] = 1
        end
        maxdiff = max(maxdiff, count - base2, count - base3, count - base5, count - base7)
        (next2 <= n) && (next2 = 2 * humble[(base2 += 1) - adjustindex])
        (next3 <= n) && (next3 = 3 * humble[(base3 += 1) - adjustindex])
        (next5 <= n) && (next5 = 5 * humble[(base5 += 1) - adjustindex])
        (next7 <= n) && (next7 = 7 * humble[(base7 += 1) - adjustindex])
    end
    savesequence, digitcounts, count, maxdiff
end

counthumbledigits(3)

@time first120, digitcounts, count, maxdiff = counthumbledigits(99)

println("\nTotal humble numbers counted: $count")
println("Maximum depth between top of array and a multiplier: $maxdiff\n")

println("The first 50 humble numbers are: $first120\n\nDigit counts of humble numbers:")
for ndigits in sort(collect(keys(digitcounts)))[1:end-1]
    println(lpad(digitcounts[ndigits], 10), " have ", lpad(ndigits, 3), " digits.")
end
