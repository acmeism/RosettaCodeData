val deck=new Deck()
val deckShuffled:Deck=deck.shuffle

println(deck)
println(deckShuffled)

val (a, rest) = deckShuffled.deal()
val (b, rest2) = rest.deal()

println(a head)
println(b head)

val (cards, rest3) =deckShuffled deal 6
println(cards)
println(rest3)
