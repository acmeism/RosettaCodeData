using Random

struct DeckDesign{T<:Integer,U<:String}
    rlen::T
    slen::T
    ranks::Vector{U}
    suits::Vector{U}
    hlen::T
end

mutable struct Deck{T<:Integer}
    cards::Vector{T}
    design::DeckDesign
end

Deck(n::Integer, des::DeckDesign) = Deck([n], des)

function pokerlayout()
    r = append!(map(string, 2:10), ["J", "Q", "K", "A"])
    s = ["\u2663", "\u2666", "\u2665", "\u2660"]
    DeckDesign(13, 4, r, s, 5)
end

function fresh(des::DeckDesign)
    Deck(collect(1:des.rlen*des.slen), des)
end
