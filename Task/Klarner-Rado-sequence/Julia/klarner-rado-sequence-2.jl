using Formatting

function KlamerRado(N)
    kr = falses(100 * N)
    kr[1] = true
    for i in 1:30N
        if kr[i]
            kr[2i + 1] = true
            kr[3i + 1] = true
        end
    end
    return [i for i in eachindex(kr) if kr[i]]
end

kr1m = KlamerRado(1000000)

println("First 100 Klarner-Rado numbers:")
foreach(p -> print(rpad(p[2], 4), p[1] % 20 == 0 ? "\n" : ""), enumerate(kr1m[1:100]))
foreach(n -> println("The ", format(n, commas=true), "th Klarner-Rado number is ",
   format(kr1m[n], commas=true)), [1000, 10000, 100000, 1000000])
