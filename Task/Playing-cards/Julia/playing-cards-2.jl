Base.isempty(d::Deck) = isempty(d.cards)
Base.empty!(d::Deck) = empty!(d.cards)
Base.length(d::Deck) = length(d.cards)
shuffle!(d::Deck) = Random.shuffle!(d.cards)
Base.sort!(d::Deck) = sort!(d.cards)
Base.getindex(d::Deck, r) = Deck(getindex(d.cards, r), d.design)
Base.size(d::Deck) = (d.design.rlen, d.design.slen)
function Base.show(io::IO, d::Deck)
    r = d.design.ranks
    s = d.design.suits
    for c in d.cards
        rix = mod1(c, d.design.rlen)
        six = div(c-1, d.design.rlen) + 1
        print(io, r[rix], s[six], " ")
    end
end
