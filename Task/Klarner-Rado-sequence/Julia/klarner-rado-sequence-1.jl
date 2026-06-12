using Formatting

function KlarnerRado(N)
    K = [1]
    for i in 1:N
        j = K[i]
        firstadd, secondadd = 2j + 1, 3j + 1
        if firstadd < K[end]
            pos = findlast(<(firstadd), K) + 1
            K[pos] != firstadd && insert!(K, pos, firstadd)
        elseif K[end] != firstadd
            push!(K, firstadd)
        end
        if secondadd < K[end]
            pos = findlast(<(secondadd), K) + 1
            K[pos] != secondadd && insert!(K, pos, secondadd)
        elseif K[end] != secondadd
            push!(K, secondadd)
        end
    end
    return K
end

kr1m = KlarnerRado(1_000_000)

println("First 100 Klarner-Rado numbers:")
foreach(p -> print(rpad(p[2], 4), p[1] % 20 == 0 ? "\n" : ""), enumerate(kr1m[1:100]))
foreach(n -> println("The ", format(n, commas=true), "th Klarner-Rado number is ",
   format(kr1m[n], commas=true)), [1000, 10000, 100000, 1000000])
