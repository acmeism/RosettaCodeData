import std/[algorithm, math, random, sequtils, strformat, strutils]

type

  # Card features.
  Number {.pure.} = enum One, Two, Three
  Color {.pure.} = enum Red, Green, Purple
  Symbol {.pure.} = enum Oval, Squiggle, Diamond
  Shading {.pure.} = enum Solid, Open, Striped

  # Cards and list of cards.
  Card = tuple[number: Number; color: Color; symbol: Symbol; shading: Shading]
  Triplet = array[3, Card]
  Deck = array[81, Card]


proc `$`(card: Card): string =
  ## Return the string representation of a card.
  toLowerAscii(&"{card.number} {card.color} {card.symbol} {card.shading}")

proc `$`(triplet: Triplet): string =
  ## Return the string representation of a triplet.
  for card in sorted(triplet):
    result.addSep(" ", 0)
    result.add &"({card})"


proc initDeck(): Deck =
  ## Create a new deck.
  var i = 0
  for num in Number.low..Number.high:
    for col in Color.low..Color.high:
      for sym in Symbol.low..Symbol.high:
        for sh in Shading.low..Shading.high:
          result[i] = (number: num, color: col, symbol: sym, shading: sh)
          inc i


proc isSet(triplet: Triplet): bool =
  ## Check if a triplets of cards is a set.
  sum(triplet.mapIt(ord(it.number))) mod 3 == 0 and
  sum(triplet.mapIt(ord(it.color))) mod 3 == 0 and
  sum(triplet.mapIt(ord(it.symbol))) mod 3 == 0 and
  sum(triplet.mapIt(ord(it.shading))) mod 3 == 0


proc sets(cards: seq[Card]): seq[Triplet] =
  ## Return the list of sets found with the given cards.
  let nCards = cards.len
  for i in 0..(nCards - 3):
    for j in (i + 1)..(nCards - 2):
      for k in (j + 1)..(nCards - 1):
        let triplet = [cards[i], cards[j], cards[k]]
        if triplet.isSet():
          result.add triplet


proc dealAndFindSets(n: Positive; displayCards = true) =
  ## Initialize and shuffle a deck, deal "n" cards,
  ## then find and display the sets present if any.

  # Initialize a deck.
  var deck = initDeck()
  deck.shuffle()

  # Deal cards.
  let cards = deck[0..<n]
  echo &"Cards dealt: {n}\n"
  if displayCards:
    for card in sorted(cards):
      echo card
    echo()

  # Find sets.
  let setList = sets(cards)
  echo &"Sets found: {setList.len}\n"
  if setList.len > 0 and displayCards:
    for triplet in setList:
      echo triplet
    echo()


when isMainModule:
  randomize()
  for ncards in [4, 8, 12]:
    dealAndFindSets(ncards)
    echo "-------------------------------------\n"
  # Check that there are 1080 sets in the 81 cards.
  dealAndFindSets(81, false)
