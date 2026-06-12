using Formatting
using Primes
using ResumableFunctions

const MAXINMASK = 10_000_000_000 # memory on test machine could not spare a bitmask much larger than this

""" return a bitmask containing at least max_wanted cubefreenumbers """
function cubefreemask(max_wanted)
    size_wanted = Int(round(max_wanted * 1.21))
    mask = trues(size_wanted)
    p = primes(Int(floor(size_wanted^(1/3))))
    for i in p
        interval = i^3
        for j in interval:interval:size_wanted
            mask[j] = false
        end
    end
    return mask
end

""" generator for cubefree numbers up to max_wanted in number """
@resumable function nextcubefree(max_wanted = MAXINMASK)
    cfmask = cubefreemask(max_wanted)
    @yield 1
    for i in firstindex(cfmask)+1:lastindex(cfmask)
        if cfmask[i]
            @yield i
        end
    end
    @warn "past end of allowable size of sequence A370833"
end

""" various task output with OEIS sequence A370833 """
function testA370833(toprint)
    println("First 100 terms of a[n]:")
    for (i, a) in enumerate(nextcubefree())
        if i < 101
            f = factor(a).pe # only factor the ones we want to print
            highestprimefactor = isempty(f) ? 1 : f[end][begin]
            print(rpad(highestprimefactor, 4), i % 10 == 0 ? "\n" : "")
        elseif i ∈ toprint
            highestprimefactor = (factor(a).pe)[end][begin]
            println("\n The ", format(i, commas = true), "th term of a[n] is ",
               format(highestprimefactor, commas = true))
        end
        i >= toprint[end] && break
    end
end

testA370833(map(j -> 10^j, 3:Int(round(log10(MAXINMASK)))))
