import random, strutils

type
  Suit* = enum ♥, ♦, ♣, ♠

  Rank* {.pure.} = enum
    Ace = (1, "A")
    Two = (2, "2")
    Three = (3, "3")
    Four = (4, "4")
    Five = (5, "5")
    Six = (6, "6")
    Seven = (7, "7")
    Eight = (8, "8")
    Nine = (9, "9")
    Ten = (10, "10")
    Jack = (11, "J")
    Queen = (12, "Q")
    King = (13, "K")

  Card* = tuple[rank: Rank; suit: Suit]

  # Sequences of cards: synonyms for seq[Card].
  Deck* = seq[Card]
  Hand* = seq[Card]

var initRandom = false   # True if "randomize" has been called.


proc `$`*(c: Card): string =
  ## Return the representation of a card.
  $c.rank & $c.suit


proc initDeck*(): Deck =
  ## Initialize a deck.
  for suit in Suit:
    for rank in Rank:
      result.add (rank, suit)


proc shuffle*(cards: var seq[Card]) =
  ## Shuffle a list of cards (deck or hand).
  if not initRandom:
    randomize()
    initRandom = true
  random.shuffle(cards)


func `$`*(cards: seq[Card]): string =
  ## Return the representation of a list o cards.
  cards.join(" ")


func dealOne*(cards: var seq[Card]): Card =
  ## Deal one card from a list of cards.
  assert cards.len > 0
  cards.pop()


## Draw one card from a list of cards.
let draw* = dealOne


func deal*(deck: var Deck; nPlayers: Positive; nCards: Positive): seq[Hand] =
  ## Deal "nCards" cards to "nPlayers" players.
  assert deck.len >= nCards * nPlayers
  result.setLen(nPlayers)
  for n in 1..nCards:
    for p in 0..<nPlayers:
      result[p].add deck.pop()


when isMainModule:
  import strformat

  var deck = initDeck()
  deck.shuffle()
  echo "Initial deck after shuffling: "
  for i in 0..2: echo deck[(i * 13)..(i * 13 + 12)], " ..."
  echo deck[^13..^1]

  echo "\nDeal eight cards for five players from the deck:"
  var hands = deck.deal(5, 8)
  for i, hand in hands: echo &"Player {i + 1} hand: ", hand
  echo "Remaining cards: ", deck

  echo "\nAfter player 1 drew a card from the deck: "
  hands[0].add deck.draw()
  echo "Player 1 hand: ", hands[0]
  echo "Remaining cards: ", deck
