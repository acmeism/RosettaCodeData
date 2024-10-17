type DeckDesign{T<:Integer,U<:String}
    rlen::T
    slen::T
    ranks::Array{U,1}
    suits::Array{U,1}
    hlen::T
end

type Deck{T<:Integer}
    cards::Array{T,1}
    design::DeckDesign
end

Deck(n::Integer, des::DeckDesign) = Deck([n], des)

function pokerlayout()
    r = [map(string, 2:10), "J", "Q", "K", "A"]
    r = map(utf8, r)
    s = ["\u2663", "\u2666", "\u2665", "\u2660"]
    DeckDesign(13, 4, r, s, 5)
end

function fresh(des::DeckDesign)
    Deck(collect(1:des.rlen*des.slen), des)
end
