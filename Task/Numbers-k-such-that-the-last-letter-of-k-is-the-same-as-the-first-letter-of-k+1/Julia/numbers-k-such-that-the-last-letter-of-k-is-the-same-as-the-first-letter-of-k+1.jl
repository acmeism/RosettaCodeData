using Formatting, SpelledOut, UnicodePlots

const spelledcache = [spelled_out(n, lang = :en) for n in 1:999]
const firstcache, lastcache = map(first, spelledcache), map(last, spelledcache)

function inOEIS363659(n)
    lastchar = n % 1000 > 0 ? lastcache[n % 1000] : n == 0 ? 'o' : n % 1_000_000 == 0 ? 'n' : 'd'
    n += 1
    j = 0
    while n > 0
         n, j = divrem(n, 1000)
    end
    return firstcache[j] == lastchar
end

""" test the sequence """
function testOEIS363659()
    ncount = 0
    lastdigits = UInt8[]
    println("First 50 qualifying numbers:")
    for n in 0:typemax(Int32)
        if inOEIS363659(n)
            ncount += 1
            push!(lastdigits, n % 10)
            if ncount < 51
                print(rpad(n, 5), ncount % 10 == 0 ? "\n" : "")
            elseif ncount in [10^3, 10^4, 10^5, 10^6, 10^7, 10^8]
                println("\nThe $(spelled_out(ncount))th number is $(format(n, commas = true)).")
                println("Breakdown by last digit of the qualifiers up to this:")
                display(histogram(lastdigits, nbins = 10))
                println()
                ncount == 100_000_000 && break
            end
        end
    end
end

testOEIS363659()
