function deal!(d::Deck, hlen::T) where T<:Integer
    if hlen < length(d)
        hand = Deck(d.cards[1:hlen], d.design)
        d.cards = d.cards[hlen+1:end]
    else
        hand = d
        empty!(d)
    end
    return hand
end

function deal!(d::Deck)
    deal!(d, d.design.hlen)
end

function pretty(d::Deck)
    s = ""
    llen = d.design.rlen
    dlen = length(d)
    for i in 1:llen:dlen
        j = min(i+llen-1, dlen)
        s *= string(d[i:j]) * "\n"
    end
    strip(s)
end
