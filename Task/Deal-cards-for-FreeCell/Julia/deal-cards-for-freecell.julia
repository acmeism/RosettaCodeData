const rank  = split("A23456789TJQK", "")
const suit  = split("♣♦♥♠", "")
const deck  = Vector{String}()

const mslcg = [0]
rng() = (mslcg[1] = ((mslcg[1] * 214013 + 2531011) & 0x7fffffff)) >> 16

initdeck() = for r in rank, s in suit push!(deck, "$r$s") end

function deal(num = rand(UInt,1)[1] % 32000 + 1)
    initdeck()
    mslcg[1] = num
    println("\nGame # ", num)
    while length(deck) > 0
        choice = rng() % length(deck) + 1
        deck[choice], deck[end] = deck[end], deck[choice]
        print(" ", pop!(deck), length(deck) % 8 == 4 ? "\n" : "")
    end
end

deal(1)
deal(617)
deal()
