# https://bicyclecards.com/how-to-play/war/

using Random

const SUITS = ["♣", "♦", "♥", "♠"]
const FACES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ]
const DECK = vec([f * s for s in SUITS, f in FACES])
const rdict = Dict(DECK[i] => div(i + 3, 4) for i in eachindex(DECK))

deal2(deck) = begin d = shuffle(deck); d[1:2:51], d[2:2:52] end

function turn!(d1, d2, pending)
    (isempty(d1) || isempty(d2)) && return false
    c1, c2 = popfirst!(d1), popfirst!(d2)
    r1, r2 = rdict[c1], rdict[c2]
    print(rpad(c1, 10), rpad(c2, 10))
    if r1 > r2
        println("Player 1 takes the cards.")
        push!(d1, c1, c2, pending...)
        empty!(pending)
    elseif r1 < r2
        println("Player 2 takes the cards.")
        push!(d2, c2, c1, pending...)
        empty!(pending)
    else # r1 == r2
        println("Tie!")
        (isempty(d1) || isempty(d2)) && return false
        c3, c4 = popfirst!(d1), popfirst!(d2)
        println(rpad("?", 10), rpad("?", 10), "Cards are face down.")
        return turn!(d1, d2, push!(pending, c1, c2, c3, c4))
    end
    return true
end

function warcardgame()
    deck1, deck2 = deal2(DECK)
    while turn!(deck1, deck2, []) end
    if isempty(deck2)
        if isempty(deck1)
            println("Game ends as a tie.")
        else
            println("Player 1 wins the game.")
        end
    else
        println("Player 2 wins the game.")
    end
end

warcardgame()
