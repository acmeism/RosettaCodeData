import Random: shuffle
import Combinatorics: combinations

const NUMBERS = ["one", "two", "three"]
const SHADINGS = ["solid", "striped", "open"]
const COLORS = ["red", "green", "purple"]
const SYMBOLS = ["diamond", "oval", "squiggle"]

struct SetCard
    t::Tuple{UInt8, UInt8, UInt8, UInt8}
    function SetCard(num, sha, col, sym)
        @assert all(i -> 1 <= i <= 3, (num, sha, col, sym))
        return new(tuple(num, sha, col, sym))
    end
end

function Base.string(s::SetCard)
    return "(" *
           join([NUMBERS[s.t[1]], SHADINGS[s.t[2]], COLORS[s.t[3]], SYMBOLS[s.t[4]]], " ") *
           (s.t[1] == 1 ? "" : "s") * ")"
end
Base.print(io:: IO, sc::SetCard) = print(io, string(sc))
Base.print(io:: IO, vsc::Vector{SetCard}) = print(io, "[" * join(string.(vsc), ", ") * "]")

"""  Return an iterator for a vector of the sets found in the dealt `cards` """
function process_deal(cards::Vector{SetCard})
    return Iterators.filter(combinations(cards, 3)) do c
        return all(i -> (c[1].t[i] + c[2].t[i] + c[3].t[i]) % 3 == 0, eachindex(c[1].t))
    end
end

function testcardsets()
    pack = vec([SetCard(n, sh, c, sy) for n in 1:3, sh in 1:3, c in 1:3, sy in 1:3])
    numcards = 81
    while !isnothing(numcards)
        print("\n\nEnter number of cards to deal (3 to 81, or just a space to exit) => ")
        numcards = tryparse(Int, readline())
        if !isnothing(numcards) && 3 <= numcards <= 81
            deal = shuffle(pack)[begin:numcards]
            sets = collect(process_deal(deal))
            println("\nThe deal is:\n$deal\n\nThere are $(length(sets)) sets.")
            foreach(println, sets)
        end
    end
end

testcardsets()
