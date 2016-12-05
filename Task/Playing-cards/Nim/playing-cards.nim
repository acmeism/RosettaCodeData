import math
randomize()

proc shuffle[T](x: var seq[T]) =
 for i in countdown(x.high, 0):
   let j = random(i + 1)
   swap(x[i], x[j])

type
  Suit = enum ♥, ♦, ♣, ♠

  Pip = enum c02, c03, c04, c05, c06, c07, c08, c09, c10, cQu, cKi, cAs

  Card = object
    pip: Pip
    suit: Suit

  Deck = object
    cards: seq[Card]

proc `$`(c: Card): string = $c.pip & $c.suit

proc initDeck(): Deck =
  result = Deck(cards: @[])
  for suit in Suit:
    for pip in Pip:
      result.cards.add Card(pip: pip, suit: suit)

proc `$`(d: Deck): string = $d.cards

proc shuffle(d: var Deck) = shuffle(d.cards)

proc deal(d: var Deck): Card =
  d.shuffle()
  d.cards.pop()

var d = initDeck()
echo "40 cards from a deck:"
for i in 0..4:
  for j in 0..7:
    stdout.write($d.deal(), " ")
  echo ""
echo "The remaining cards are: ", $d
