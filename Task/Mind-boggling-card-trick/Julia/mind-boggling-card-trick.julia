using Random

const rbdeck = split(repeat('R', 26) * repeat('B', 26), "")
shuffledeck() = shuffle(rbdeck)

function deal!(deck, dpile, bpile, rpile)
    while !isempty(deck)
        if (topcard = pop!(deck)) == "R"
            push!(rpile, pop!(deck))
        else
            push!(bpile, pop!(deck))
        end
        push!(dpile, topcard)
    end
end

function swap!(rpile, bpile, nswapping)
    rpick = sort(randperm(length(rpile))[1:nswapping])
    bpick = sort(randperm(length(bpile))[1:nswapping])
    rrm = rpile[rpick]; brm = bpile[bpick]
    deleteat!(rpile, rpick); deleteat!(bpile, bpick)
    append!(rpile, brm); append!(bpile, rrm)
end

function mindbogglingcardtrick(verbose=true)
    prif(cond, txt) = (if(cond) println(txt) end)
    deck = shuffledeck()
    prif(verbose, "Shuffled deck is: $deck")

    dpile, rpile, bpile = [], [], []
    deal!(deck, dpile, bpile, rpile)

    prif(verbose, "Before swap:")
    prif(verbose, "Discard pile:    $dpile")
    prif(verbose, "Red card pile:   $rpile")
    prif(verbose, "Black card pile: $bpile")

    amount = rand(1:min(length(rpile), length(bpile)))
    prif(verbose, "Swapping a random number of cards: $amount will be swapped.")
    swap!(rpile, bpile, amount)

    prif(verbose, "Red pile after swaps:   $rpile")
    prif(verbose, "Black pile after swaps: $bpile")
    println("There are $(sum(map(x->x=="B", bpile))) black cards in the black card pile:")
    println("there are $(sum(map(x->x=="R", rpile))) red cards in the red card pile.")
    prif(verbose, "")
end

mindbogglingcardtrick()

for _ in 1:10
    mindbogglingcardtrick(false)
end
