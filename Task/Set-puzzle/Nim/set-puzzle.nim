import algorithm, math, random, sequtils, strformat, strutils

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

  # Game level.
  Level {.pure.} = enum Basic = "basic", Advanced = "advanced"


proc `$`(card: Card): string =
  ## Return the string representation of a card.
  toLowerAscii(&"{card.number:<5}  {card.color:<6}  {card.symbol:<8}  {card.shading:<7}")


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


proc playGame(level: Level) =
  ## Play the game at given level.

  var deck = initDeck()
  let (nCards, nSets) = if level == Basic: (9, 4) else: (12, 6)
  var sets: seq[Triplet]
  var hand: seq[Card]
  echo &"Playing {level} game: {nCards} cards, {nSets} sets."

  block searchHand:
    while true:
      sets.setLen(0)
      deck.shuffle()
      hand = deck[0..<nCards]
      block countSets:
        for i in 0..(nCards - 3):
          for j in (i + 1)..(nCards - 2):
            for k in (j + 1)..(nCards - 1):
              let triplet = [hand[i], hand[j], hand[k]]
              if triplet.isSet():
                sets.add triplet
                if sets.len > nSets:
                  break countSets   # Too much sets. Try with a new hand.
        if sets.len == nSets:
          break searchHand    # Found: terminate search.

  # Display the hand and the sets.
  echo "\nCards:"
  for card in sorted(hand): echo "    ", card
  echo "\nSets:"
  for s in sets:
    for card in sorted(s): echo "    ", card
    echo()


randomize()
playGame(Basic)
echo()
playGame(Advanced)
