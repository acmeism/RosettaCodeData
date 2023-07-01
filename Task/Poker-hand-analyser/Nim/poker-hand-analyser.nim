import algorithm, sequtils, strutils, tables, unicode

type

  Suit* = enum ♠, ♥, ♦, ♣
  Face* {.pure.} = enum
    Ace = (1, "a")
    Two = (2, "2")
    Three = (3, "3")
    Four = (4, "4")
    Five = (5, "5")
    Six = (6, "6")
    Seven = (7, "7")
    Eight = (8, "8")
    Nine = (9, "9")
    Ten = (10, "10")
    Jack = (11, "j")
    Queen = (12, "q")
    King = (13, "k")

  Card* = tuple[face: Face; suit: Suit]
  Hand* = array[5, Card]

  HandValue {.pure.} = enum
    Invalid = "invalid"
    StraightFlush = "straight-flush"
    FourOfAKind = "four-of-a-kind"
    FullHouse = "full-house"
    Flush = "flush"
    Straight = "straight"
    ThreeOfAKind = "three-of-a-kind"
    TwoPair = "two-pair"
    OnePair = "one-pair"
    HighCard = "high-card"

  CardError = object of ValueError


proc toCard(cardStr: string): Card =
  ## Convert a card string to a Card.
  var runes = cardStr.toRunes
  let suitStr = $(runes.pop())  # Extract the suit.
  let faceStr = $runes          # Take what’s left as the face.
  try:
    result.face = parseEnum[Face](faceStr)
  except ValueError:
    raise newException(CardError, "wrong face: " & faceStr)
  try:
    result.suit = parseEnum[Suit](suitStr)
  except ValueError:
    raise newException(CardError, "wrong suit: " & suitStr)


proc value(hand: openArray[Card]): HandValue =
  ## Return the value of a hand.

  doAssert hand.len == 5, "Hand must have five cards."

  var
    cards: seq[Card]          # The cards.
    faces: CountTable[Face]   # Count faces.
    suits: CountTable[Suit]   # Count suits.

  for card in hand:
    if card in cards: return Invalid    # Duplicate card.
    cards.add card
    faces.inc card.face
    suits.inc card.suit

  faces.sort()  # Greatest counts first.
  suits.sort()  # Greatest counts first.
  cards.sort()  # Smallest faces first.

  # Check faces.
  for face, count in faces:
    case count
    of 4:
      return FourOfAKind
    of 3:
      result = ThreeOfAKind
    of 2:
      if result == ThreeOfAKind: return FullHouse
      if result == OnePair: return TwoPair
      result = OnePair
    else:
      if result != Invalid: return

  # Search straight.
  result = Straight
  let start = if cards[0].face == Ace and cards[4].face == King: 2 else: 1
  for n in start..4:
    if cards[n].face != succ(cards[n - 1].face):
      result = HighCard   # No straight.
      break

  # Check suits.
  if suits.len == 1:   # A single suit.
    result = if result == Straight: StraightFlush else: Flush


proc `$`(card: Card): string =
  ## Return the representation of a card.
  var val = 0x1F0A0 + ord(card.suit) * 0x10 + ord(card.face)
  if card.face >= Queen: inc val    # Skip Knight.
  result = $Rune(val)



when isMainModule:

  const HandStrings = ["2♥ 2♦ 2♣ k♣ q♦",
                       "2♥ 5♥ 7♦ 8♣ 9♠",
                       "a♥ 2♦ 3♣ 4♣ 5♦",
                       "2♥ 3♥ 2♦ 3♣ 3♦",
                       "2♥ 7♥ 2♦ 3♣ 3♦",
                       "2♥ 7♥ 7♦ 7♣ 7♠",
                       "10♥ j♥ q♥ k♥ a♥",
                       "4♥ 4♠ k♠ 5♦ 10♠",
                       "q♣ 10♣ 7♣ 6♣ 4♣",
                       "4♥ 4♣ 4♥ 4♠ 4♦"]

  for handString in HandStrings:
    let hand = handString.split(' ').map(toCard)
    echo hand.map(`$`).join("  "), "  → ", hand.value
