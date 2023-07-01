import strformat
import playing_cards

const
  None = -1
  Player1 = 0
  Player2 = 1

type Player = range[None..Player2]

const PlayerNames: array[Player1..Player2, string] = ["Player 1", "Player 2"]

#---------------------------------------------------------------------------------------------------

proc `<`(a, b: Card): bool =
  ## Compare two cards by their rank, Ace being the greatest.
  if a.rank == Ace: false
  elif b.rank == Ace: true
  else: a.rank < b.rank

#---------------------------------------------------------------------------------------------------

proc displayRound(round: int; hands: openArray[Hand]; card1, card2: string; text: string) =
  ## Display text for a round.
  stdout.write &"Round {round:<4}     "
  stdout.write &"Cards: {hands[Player1].len:>2}/{hands[Player2].len:<2}     "
  stdout.write &"{card1:>3}    {card2:>3}    "
  echo text

#---------------------------------------------------------------------------------------------------

proc outOfCards(player: Player) =
  ## Display a message when a player has run out of cards.
  echo &"{PlayerNames[player]} has run out of cards."

#---------------------------------------------------------------------------------------------------

proc doRound(hands: var openArray[Hand]; num: Positive) =
  ## Execute a round.

  var stack1, stack2: seq[Card]
  var winner: Player = None

  while winner == None:
    let card1 = hands[Player1].draw()
    let card2 = hands[Player2].draw()
    stack1.add card1
    stack2.add card2
    if card1.rank != card2.rank:
      winner = if card1 < card2: Player2 else: Player1
      displayRound(num, hands, $card1, $card2, &"{PlayerNames[winner]} takes the cards.")
    else:
      # There is a war.
      displayRound(num, hands, $card1, $card2, "This is a war.")
      if hands[Player1].len == 0:
        winner = Player2
      elif hands[Player2].len == 0:
        winner = Player1
      else:
        # Add a hidden card on stacks.
        stack1.add hands[Player1].draw()
        stack2.add hands[Player2].draw()
        displayRound(num, hands, "  ?", "  ?", "Cards are face down.")
        # Check if each player has enough cards to continue the war.
        if hands[Player1].len == 0:
          Player1.outOfCards()
          winner = Player2
        elif hands[Player2].len == 0:
          Player2.outOfCards()
          winner = Player1

  # Update hands.
  var stack = stack1 & stack2
  stack.shuffle()
  hands[winner] = stack & hands[winner]


#———————————————————————————————————————————————————————————————————————————————————————————————————

var deck = initDeck()
deck.shuffle()

var hands = deck.deal(2, 26)
var num = 0
while true:
  inc num
  hands.doRound(num)
  if hands[Player1].len == 0:
    echo "Player 2 wins this game."
    break
  if hands[Player2].len == 0:
    echo "Player 1 wins this game."
    break
