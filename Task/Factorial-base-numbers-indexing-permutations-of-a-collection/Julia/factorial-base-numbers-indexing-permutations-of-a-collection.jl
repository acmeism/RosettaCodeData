function makefactorialbased(N, makelist)
    listlist = Vector{Vector{Int}}()
    count = 0
    while true
        divisor = 2
        makelist && (lis = zeros(Int, N))
        k = count
        while k > 0
            k, r = divrem(k, divisor)
            makelist && (divisor <= N + 1) && (lis[N - divisor + 2] = r)
            divisor += 1
        end
        if divisor > N + 2
            break
        end
        count += 1
        makelist && push!(listlist, lis)
    end
    return count, listlist
end

function facmap(factnumbase)
    perm = [i for i in 0:length(factnumbase)]
    for (n, g) in enumerate(factnumbase)
        if g != 0
            perm[n:n + g] .= circshift(perm[n:n + g], 1)
        end
    end
    perm
end

function factbasenums()
    fcount, factnums = makefactorialbased(3, true)
    perms = map(facmap, factnums)
    for (i, fn) = enumerate(factnums)
        println("$(join(string.(fn), ".")) -> $(join(string(perms[i]), ""))")
    end

    fcount, _ = makefactorialbased(10, false)
    println("\nPermutations generated = $fcount, and 11! = $(factorial(11))\n")

    taskrandom = ["39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
        "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"]
    perms = map(s -> facmap([parse(Int, s) for s in split(s, ".")]), taskrandom)

    cardshoe = split("A♠K♠Q♠J♠T♠9♠8♠7♠6♠5♠4♠3♠2♠A♥K♥Q♥J♥T♥9♥8♥7♥6♥5♥4♥3♥2♥A♦K♦Q♦J♦T♦9♦8♦7♦6♦5♦4♦3♦2♦A♣K♣Q♣J♣T♣9♣8♣7♣6♣5♣4♣3♣2♣", "")
    cards = [cardshoe[2*i+1] * cardshoe[2*i+2] for i in 0:51]
    printcardshuffle(t, c, o) = (println(t); for i in 1:length(o) print(c[o[i] + 1]) end; println())

    println("\nTask shuffles:")
    map(i -> printcardshuffle(taskrandom[i], cards, perms[i]), 1:2)

    myran = [rand(collect(0:i)) for i in 51:-1:1]
    perm = facmap(myran)
    println("\nMy random shuffle:")
    printcardshuffle(join(string.(myran), "."), cards, perm)
end

factbasenums()
