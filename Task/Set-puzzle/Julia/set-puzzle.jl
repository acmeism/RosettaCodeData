using Random, IterTools, Combinatorics

function SetGameTM(basic = true)
    drawsize = basic ? 9 : 12
    setsneeded = div(drawsize, 2)
    setsof3 = Vector{Vector{NTuple{4, String}}}()
    draw = Vector{NTuple{4, String}}()
    deck = collect(Iterators.product(["red", "green", "purple"], ["one", "two", "three"],
        ["oval", "squiggle", "diamond"], ["solid", "open", "striped"]))

    while length(setsof3) != setsneeded
        empty!(draw)
        empty!(setsof3)
        map(x -> push!(draw, x), shuffle(deck)[1:drawsize])
        for threecards in combinations(draw, 3)
            canuse = true
            for i in 1:4
                u = length(unique(map(x->x[i], threecards)))
                if u != 3 && u != 1
                    canuse = false
                end
            end
            if canuse
                push!(setsof3, threecards)
            end
        end
    end

    println("Dealt $drawsize cards:")
    for card in draw
        println("    $card")
    end
    println("\nFormed these cards into $setsneeded sets:")
    for set in setsof3
        for card in set
            println("    $card")
        end
        println()
    end
end

SetGameTM()
SetGameTM(false)
