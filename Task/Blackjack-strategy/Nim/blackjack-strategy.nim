import random, sequtils, strformat, strutils

type

  Card = 1..10

  Deck = object
    size: int
    cards: array[Card, int]

  HandKind {.pure.} = enum Hard, Soft, Pair

  Action {.pure.} = enum Stand, Hit, Double, Split

  ActionGain = tuple[action: Action; gain: float]


var

  # Computed strategy tables.
  hTable: array[15, array[10, Action]]    # Hard strategy table (round 1).
  sTable: array[8, array[10, Action]]     # Soft strategy table (round 1).
  pTable: array[10, array[10, Action]]    # Pairs strategy table (round 1).
  hTable2: array[18, array[10, Action]]   # Hard strategy table (round >= 2, no doubling).
  sTable2: array[10, array[10, Action]]   # Soft strategy table (round >= 2, no doubling).



func initDeck(): Deck =
  Deck(size: 52, cards: [4, 4, 4, 4, 4, 4, 4, 4, 4, 16])


func `<`(ag1, ag2: ActionGain): bool = ag1.gain < ag2.gain


func dealerProbs(upcard: Card; startDeck: Deck): array[7, float] =
  ## Returns probabilities of dealer eventually getting:
  ## 0: 17, 1: 18, 2: 19, 3: 20, 4: 21 (non-blackjack), 5: blackjack (nil), 6: bust.
  ## It is assumed that the dealer has already checked for blackjack, that one deck is used
  ## and that the dealer stands on 'soft' 17.

  var
    res: array[7, float]    # Results.
    decks: array[9, Deck]   # Decks for each level.
    scores: array[9, int]   # Scores for each level.
    elevens: array[9, int]  # Number of aces for each level scored as 11.
    probs: array[9, float]  # Probabilities for each level.

  decks[0] = startDeck
  scores[0] = upCard
  if upcard == 1:
    # An ace.
    scores[0] = 11
    elevens[0] = 1

  probs[0] = 1.0

  proc drawCard(lev: Natural) =
    ## Recursive closure.
    for c in Card.low..Card.high:
      if decks[lev].cards[c] == 0: continue   # Card no longer present in deck.

      # Temporary variables for current level.
      var
        deck = decks[lev]
        score = scores[lev]
        eleven = elevens[lev]
        prob = probs[lev]

      inc score, c  # Add card to score.
      if c == 1:
        # Score all aces initially as 11.
        inc score, 10
        inc eleven

      prob *= deck.cards[c] / deck.size
      if score > 21 and eleven > 0:
        dec score, 10   # Bust but can demote an ace.
        dec eleven

      if lev == 0 and (upCard == 1 and c == 10 or upCard == 10 and c == 1):
        res[5] += prob          # Blackjack, allow for now.
      elif score in 17..21:
        res[score-17] += prob   # 17 to (non-blackjack) 21.
      elif score > 21 and eleven == 0:
        res[6] += prob          # Bust.
      else:
        dec deck.cards[c]   # Remove card from deck.
        dec deck.size
        let lev = lev + 1
        decks[lev] = deck
        scores[lev] = score
        elevens[lev] = eleven
        probs[lev] = prob
        drawCard(lev)

  drawCard(0)
  # But can't have blackjack, so adjust probabilities accordingly.
  let pnbj = 1 - res[5]
  for i in 0..6: res[i] /= pnbj

  res[5] = 0
  result = res


proc dealerChart =
  ## Print chart of dealer probabilities (as a check against an external source).
  echo "Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules"
  echo "Up Card     17        18        19        20        21       Bust"
  echo "———————————————————————————————————————————————————————————————————"
  var deck = initDeck()
  deck.size = 51
  for uc in Card.low..Card.high:
    var deck2 = deck
    dec deck2.cards[uc]
    let dp = dealerProbs(uc, deck2)
    stdout.write if uc > 1: &"{uc:3}    " else: "Ace    "
    for i in [0, 1, 2, 3, 4, 6]: stdout.write &"  {dp[i]:.6f}"
    echo()


func calcGain(pscore: int; dp: openArray[float]): float =
  ## Calculates gain per unit staked for a given scenario (helper function).
  case pscore
  of 17:
    result += dp[6]                                 # Dealer is bust.
    result -= dp[1] + dp[2] + dp[3] + dp[4]         # Dealer has 18 to 21.
  of 18:
    result += dp[0] + dp[6]                         # Dealer has 17 or is bust.
    result -= dp[2] + dp[3] + dp[4]                 # Dealer has 19 to 21.
  of 19:
    result += dp[0] + dp[1] + dp[6]                 # Dealer has 17, 18 or is bust.
    result -= dp[3] + dp[4]                         # Dealer has 20 or 21.
  of 20:
    result += dp[0] + dp[1] + dp[2] + dp[6]         # Dealer has 17 to 19 or is bust.
    result -= dp[4]                                 # Dealer has (non-blackjack) 21.
  of 21:
    result += dp[0] + dp[1] + dp[2] + dp[3] + dp[6] # Dealer has 17 to 20 or is bust.
  of 22: # Notional.
    result += 1.5                                   # Player blackjack.
  of 23: # Notional.
    result -= 1       # Player bust, loses stake irrespective of what dealer has.
  else: # Player has less than 17
    result += dp[6]                                 # Dealer is bust.
    result -= 1 - dp[6]                             # Dealer isn't bust.


func playerGain(card1, card2, uc: Card; startDeck: Deck): float =
  ## Returns player's expected gain per unit staked after hitting once and then standing.
  let deck = startDeck
  var
    score = card1 + card2
    eleven = false
  if card1 == 1 or card2 == 1:
    inc score, 10
    eleven = true

  for c in Card.low..Card.high:
    # Get another card.
    if deck.cards[c] == 0: continue   # Card no longer present in deck.
    # Temporary variables for current card.
    var
      deck2 = deck
      score2 = score
      eleven2 = eleven

    inc score2, c   # Add card to score.
    if c == 1:
      # Score all aces initially as 11.
      inc score2, 10
      eleven2 = true

    let prob = deck2.cards[c] / deck2.size
    dec deck2.cards[c]
    dec deck2.size
    if score2 > 21 and eleven2:
      dec score2, 10  # Bust but can demote an ace.
    if score2 <= 21:
      let dp = dealerProbs(uc, deck2)
      result += calcGain(score2, dp) * prob
    else:
      # Bust.
      result -= prob


func playerGain2(card1, card2, uc: Card; startDeck: Deck): float =
  ## Return player's expected gain per unit staked after hitting once
  ## and then continuing in accordance with the tables for rounds >= 2.

  var
    eg = 0.0                # Result.
    decks: array[9, Deck]   # Decks for each level.
    scores: array[9, int]   # Scores for each level.
    elevens: array[9, int]  # Number of aces for each level scored as 11.
    probs: array[9, float]  # Probabilities for each level.
  decks[0] = startDeck
  scores[0] = card1 + card2
  if card1 == 1 or card2 == 1:
    inc scores[0], 10
    elevens[0] = 1

  probs[0] = 1.0

  proc drawCard(lev: Natural) =
    ## Recursive closure.
    for c in Card.low..Card.high:
      if decks[lev].cards[c] == 0: continue   # Card no longer present in deck.

      # Temporary variables for current level.
      var
        deck = decks[lev]
        score = scores[lev]
        eleven = elevens[lev]
        prob = probs[lev]

      inc score, c  # Add card to score.
      if c == 1:
        # Score all aces initially as 11.
        inc score, 10
        inc eleven

      prob *= deck.cards[c] / deck.size
      if score > 21 and eleven > 0:
        dec score, 10   # Bust but can demote an ace.
        dec eleven

      dec deck.cards[c] # Remove card from deck.
      dec deck.size

      if (eleven == 0 and (score >= 17 or score >= 13 and uc < 7) or
          eleven == 0 and score == 12 and uc >= 4 and  uc <= 6 or
          eleven > 0 and score == 18 and uc != 9 and  uc != 10 or
          eleven > 0 and score >= 19) and score <= 21:
          let dp = dealerProbs(uc, deck)
          eg += calcGain(score, dp) * prob
      elif score > 21 and eleven == 0:
        # Bust.
        eg -= prob
      else:
        let lev = lev + 1
        decks[lev] = deck
        scores[lev] = score
        elevens[lev] = eleven
        probs[lev] = prob
        drawCard(lev)

  drawCard(0)
  result = eg


func stand(card1, card2: Card): array[10, float] =
  ## Return player's expected gains per unit staked, for each dealer up-card, after standing.

  var deck = initDeck()
  dec deck.cards[card1]
  dec deck.cards[card2]
  deck.size = 50
  var pscore = card1 + card2    # Player score.
  if card1 == 1 or card2 == 1:
    inc pscore, 10

  for uc in Card.low..Card.high:  # Dealer's up-card.
    var deck2 = deck
    dec deck2.cards[uc]
    dec deck2.size
    let dp = dealerProbs(uc, deck2)
    let eg = calcGain(pscore, dp)   # Expected gain for this up-card.
    if uc > 1:
      result[uc-2] = eg
    else: # Dealer has Ace.
      result[9] = eg  # Ace comes last in tables.


func hit(card1, card2: Card; once: bool): array[10, float] =
  ## Return player's expected gains per unit staked, for each dealer
  ## up-card, after hitting once and then either standing (once == true)
  ## or continuing as per the round >= 2 tables (once == false).
  var deck = initDeck()
  dec deck.cards[card1]
  dec deck.cards[card2]
  deck.size = 50
  for uc in Card.low..Card.high:  # Dealer's up-card.
    var deck2 = deck
    dec deck2.cards[uc]
    deck2.size = 49
    # Player's expected gain for this up-card.
    let peg = if once: playerGain(card1, card2, uc, deck2)
              else: playerGain2(card1, card2, uc, deck2)
    if uc > 1:
      result[uc-2] = peg
    else: # Dealer has Ace.
      result[9] = peg


func double(card1, card2: Card): array[10, float] =
  ## Return player's expected gains per unit originally staked,
  ## for each dealer up-card, after doubling i.e. hitting once
  ## and then standing with a doubled stake.
  result = hit(card1, card2, true)   # Hit once and then stand.
  for item in result.mitems:
    item *= 2


proc split(card: Card): array[10, float] =
  ## Return player's expected gains per unit originally staked, for each dealer up-card, after
  ## splitting a pair and doubling the stake, getting a second card for each hand and then
  ## continuing in accordance with the rounds >= 2 tables. It is assumed that a player cannot
  ## double or re-split following a split. It is also assumed (in the interests of simplicity)
  ## that the expected gains for each split hand (after calculating the gains for the first hand
  ## as though the second hand is not completed) are exactly the same.
  var deck = initDeck()
  dec deck.cards[card], 2   # Must be a pair.
  deck.size = 50

  # Now play a single hand.
  var score: int = card
  var eleven = 0
  if card == 1:
    score = 11
    eleven = 1

  for uc in Card.low..Card.high:  # Collect results for each dealer up-card.
    if deck.cards[uc] == 0: continue   # Card no longer present in deck.

    var deck2 = deck
    dec deck2.cards[uc]
    dec deck2.size
    var ix = uc - 2
    if ix == -1: ix = 9   # In tables ace comes last.
    var peg: float  # Player expected gain for this up-card.
    # Get second player card.
    for c in Card.low..Card.high:
      if deck2.cards[c] == 0: continue   # Card no longer present in deck.

      let prob = deck2.cards[c] / deck2.size
      var deck3 = deck2
      dec deck3.cards[c]
      dec deck3.size
      var score2 = score + c
      var eleven2 = eleven
      if c == 1:
        # Score all aces initially as 11.
        inc score2, 10
        inc eleven2

      if score2 == 21:
        # Player has blackjack & we know dealer hasn't.
        peg += 1.5 * prob
        continue

      if score2 > 21 and eleven2 > 0:
        dec score2, 10  # Bust but can demote an ace.
        dec eleven2

      let action = if eleven2 > 0: sTable2[score2-12][ix] # Use soft strategy table, no doubling.
                   else:  hTable2[score2-4][ix]           # Use hard strategy table, no doubling
      let peg2 =  if action == Stand: calcGain(score2, dealerProbs(uc, deck3))
                  else: playerGain2(card, c, uc, deck3)
      peg += peg2 * prob

    if uc > 1:
      result[uc-2] = peg * 2    # Allow for both hands in overall results.
    else:
      result[9] = peg * 2       # Ditto.


func bestAction(ags: openArray[ActionGain]): Action =
  ## Return the action with the highest expected gain.
  ags[ags.maxIndex()].action


proc printHeader(title: string) =
  ## Print title and header for a given chart.
  echo title
  echo "P/D     2      3      4      5      6      7      8      9      T      A"
  echo "——————————————————————————————————————————————————————————————————————————"


proc printPair(c: Card) =
  ## Print header for a pair of cards.
  stdout.write if c == 1: "AA   " elif c == 10: "TT   " else: &"{c}{c}   "


func dealerPlay(pscore: int, next: var int; cards, d: openArray[Card]): float =
  ## Simulate a dealer's play for a given player's hand and state of deck.
  ## Return the player's gain (positive or negative) per unit staked.
  var dscore = d[0] + d[1]
  var aces = 0
  if d[0] == 1 or d[1] == 1:
    # Dealer has an ace.
    inc dscore, 10
    inc aces

  while true:
    if dscore > 21 and aces > 0:
      dec dscore, 10    # Bust but we can demote an ace.
      dec aces
    if dscore > 21:
      return 1      # Dealer is bust and player gains stake.

    if dscore >= 17:
      # Dealer must stick on 17 or above, hard or not.
      if dscore > pscore:
        return -1   # Dealer wins and player loses stake.
      if dscore == pscore:
        break       # Player breaks even.
      return 1      # Dealer loses and player gains stake.

    let nc = cards[next]  # Get new card from pack.
    inc next
    inc dscore, nc
    if nc == 1:
      # Count aces initially as 11.
      inc dscore, 10
      inc aces


proc playerPlay(): (float, float) =
  ## Simulate the playing of a random player's hand according to the strategy tables.
  ## Return both the gain (positive or negative) and the stake (1 or 2).

  var perm = toSeq(0..51)
  perm.shuffle()
  var cards: array[52, Card]
  for i, r in perm:
    var card = r div 4 + 1
    if card > 10: card = 10
    cards[i] = card

  var p, d: seq[Card]   # Player and dealer hands.
  # Initial deal.
  p.add cards[0..1]
  d.add cards[2..3]
  var next = 4    # Index of next card to be dealt.

  # Check if dealer and/or player have blackjack.
  let dbj = d[0] == 1 and d[1] == 10 or d[0] == 10 and d[1] == 1
  let pbj = p[0] == 1 and p[1] == 10 or p[0] == 10 and p[1] == 1
  if dbj:
    if pbj: return (0.0, 1.0) # Player neither wins nor loses.
    else: return (-1.0, 1.0)  # Player loses stake.
  if pbj: return (1.5, 1.0)   # Player wins 1.5 x stake.

  var uc = d[0] - 2       # Dealer's up-card as index to access tables.
  if uc < 0: uc = 9       # Ace is at last place in tables.

  var stake = 1.0             # Player's initial stake.
  var fscores: array[2, int]  # Final player scores (one or, after split, two hands).
  var action: Action
  var score, aces: int

  proc h(hand: int) =
    ## Process a hit.
    while true:
      let nc = cards[next]  # Get new card from pack.
      inc next
      inc score, nc
      if nc == 1:
        # Count aces initially as 11.
        inc score, 10
        inc aces
      if score > 21 and aces > 0:
        dec score, 10   # Bust but we can demote an ace.
        dec aces
      if score > 21:
        fscores[hand] = 22  # Player is bust and loses stake.
        break
      if action == Double:
        fscores[hand] = score
        break
      # Get further strategy and act accordingly.
      action = if aces == 0: hTable2[score-4][uc] else: sTable2[score-12][uc]
      if action == Stand:
        fscores[hand] = score
        break

  score = p[0] + p[1]
  # Get kind of player hand: hard, soft, pair.
  let kind = if p[0] == p[1]: Pair elif p[0] == 1 or p[1] == 1: Soft else: Hard

  case kind
  of Hard:
    action = hTable[score-5][uc]
  of Soft:  # includes one ace.
    let othercard = if p[0] == 1: p[1] else: p[0]
    inc score, 10
    aces = 1
    action = sTable[otherCard-2][uc]
  of Pair:
    if p[0] == 1:
      # Pair of aces.
      inc score, 10
      aces = 2
    action = pTable[p[0]-1][uc]

  case action
  of Stand:
    fscores[0] = score
  of Hit:
    h(0)
  of Double:
    h(0)
    stake = 2
  of Split:
    for hand in 0..1:
      score = p[0]
      aces = 0
      if score == 1:
        # Count aces initially as 11.
        score = 11
        inc aces
      h(hand)

  var sum = 0.0
  if fscores[0] < 22:
    sum += dealerPlay(fscores[0], next, cards, d) * stake
  else:
    sum -= 1 * stake  # This hand is bust.
  if fscores[1] > 0:
    # Pair.
    if fscores[1] < 22:
      sum += dealerPlay(fscores[1], next, cards, d)
    else:
      sum -= 1
    stake = 2

  result = (sum, stake)


proc simulate(perDay, days: int) =
  ## Simulate "perDay" blackjack games for "days" days.

  var
    winDays, loseDays, evenDays = 0
    bigWin, bigLoss = 0.0
    totalGain, totalStake = 0.0

  for d in 1..days:
    var dailyGain, dailyStake = 0.0
    for p in 1..perDay:
      let (gain, stake) = playerPlay()
      dailyGain += gain
      dailyStake += stake

    if dailyGain > 0: inc winDays
    elif dailyGain < 0: inc loseDays
    else: inc evenDays

    if dailyGain > bigWin: bigWin = dailyGain
    elif -dailyGain > bigLoss: bigLoss = -dailyGain

    totalGain += dailyGain
    totalStake += dailyStake

  echo &"\nAfter playing {perDay} times a day for {days} days:"
  echo "Winning days:   ", winDays
  echo "Losing days:    ", loseDays
  echo "Breakeven days: ", evenDays
  echo "Biggest win:    ", bigWin
  echo "Biggest loss:   ", bigLoss
  if totalGain < 0:
    echo "Total loss:     ", -totalGain
    echo "Total staked:   ", totalStake
    echo &"Loss % staked:  {-totalGain/totalStake*100:0.3f}\n"
  else:
    echo "Total win:      ", totalGain
    echo "Total staked:   ", totalStake
    echo &"Win % staked:  {totalGain/totalStake*100:0.3f}\n"


proc main() =

  # Print dealer probabilities chart.
  dealerChart()

  # For hard scores (i.e. different cards, no aces).
  const Tuples = [(2, 3),
                  (2, 4),
                  (2, 5), (3, 4),
                  (2, 6), (3, 5),
                  (2, 7), (3, 6), (4, 5),
                  (2, 8), (3, 7), (4, 6),
                  (2, 9), (3, 8), (4, 7), (5, 6),
                  (2, 10), (3, 9), (4, 8), (5, 7),
                  (3, 10), (4, 9), (5, 8), (6, 7),
                  (4, 10), (5, 9), (6, 8),
                  (5, 10), (6, 9), (7, 8),
                  (6, 10), (7, 9),
                  (7, 10), (8, 9),
                  (8, 10),
                  (9, 10)]

  # Number of tuples for each player score from 5 to 19.
  const Counts = [float 1, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1]

  # Expected gains for each player score & for each dealer up-card.
  var
    segs: array[15, array[10, float]]  # if stands.
    hegs: array[15, array[10, float]]  # if hits.
    degs: array[15, array[10, float]]  # if doubles.

  for t in Tuples:
    let i = t[0] + t[1]
    let sg = stand(t[0], t[1])
    let hg = hit(t[0], t[1], false)
    let dg = double(t[0], t[1])
    for j in 0..9:
      segs[i-5][j] += sg[j]
      hegs[i-5][j] += hg[j]
      degs[i-5][j] += dg[j]

  # Calculate the average per tuple for each score.
  for i in 0..14:
    for j in 0..9:
      segs[i][j] /= Counts[i]
      hegs[i][j] /= Counts[i]
      degs[i][j] /= Counts[i]

  printHeader("\nHard Chart - Player Expected Gains per unit (Stand)")
  for i in 5..19:
    stdout.write &"{i:2}   "
    for j in 0..9:
      stdout.write &"{segs[i-5][j]: 0.3f} "
    echo()

  printHeader("\nHard Chart - Player Expected Gains per unit (Hit)")
  for i in 5..19:
    stdout.write &"{i:2}   "
    for j in 0..9:
      stdout.write &"{hegs[i-5][j]: 0.3f} "
    echo()

  printHeader("\nHard Chart - Player Expected Gains per unit (Double)")
  for i in 5..19:
    stdout.write &"{i:2}   "
    for j in 0..9:
      stdout.write &"{degs[i-5][j]: 0.3f} "
    echo()

  printHeader("\nHard Chart - Player Strategy (Round 1)")
  for i in 5..19:
    stdout.write &"{i:2}   "
    for j in 0..9:
      let ags = [(Stand, segs[i-5][j]), (Hit, hegs[i-5][j]), (Double, degs[i-5][j])]
      let action = bestAction(ags)
      hTable[i-5][j] = action
      stdout.write &"{action:^6} "
    echo()

  # For hard scores (no aces) - after round 1 (no doubling or splitting).
  # Based on hard table figures (round 1) with scores of 4, 20, and 21 added.
  var
    segs2: array[18, array[10, float]]   # Expected gains if stands.
    hegs2: array[18, array[10, float]]   # Expected gains if hits.
  for i in 5..19:
    segs2[i-4] = segs[i-5]
    hegs2[i-4] = hegs[i-5]

  let sg4 = stand(2, 2)
  let hg4 = hit(2, 2, false)
  let sg20 = stand(10, 10)
  let hg20 = hit(10, 10, false)
  let sg21 = stand(1, 10)
  let hg21 = hit(1, 10, false)
  for j in 0..9:
    segs2[0][j] += sg4[j]
    hegs2[0][j] += hg4[j]
    segs2[16][j] += sg20[j]
    hegs2[16][j] += hg20[j]
    segs2[17][j] += sg21[j]
    hegs2[17][j] += hg21[j]

  printHeader("\nHard Chart - Player Strategy (Round >= 2, No Doubling)")
  for i in 4..21:
    stdout.write &"{i:2}   "
    for j in 0..9:
      var action = Stand
      if hegs2[i-4][j] > segs2[i-4][j]: action = Hit
      hTable2[i-4][j] = action
      stdout.write &"{action:^6} "
    echo()

  # For soft scores (i.e. including exactly one ace).

  # Expected gains for each player second card (2 to 9) & for each dealer up-card.
  var
    segs3: array[8, array[10, float]]   # if stands.
    hegs3: array[8, array[10, float]]   # if hits.
    degs3: array[8, array[10, float]]   # if doubles.
  for c in 2..9:
    let sg = stand(1, c)
    let hg = hit(1, c, false)
    let dg = double(1, c)
    for j in 0..9:
      segs3[c-2][j] += sg[j]
      hegs3[c-2][j] += hg[j]
      degs3[c-2][j] += dg[j]

  printHeader("\nSoft Chart - Player Expected Gains per unit (Stand)")
  for c in 2..9:
    stdout.write &"A{c}   "
    for j in 0..9:
      stdout.write &"{segs3[c-2][j]: 0.3f} "
    echo()


  printHeader("\nSoft Chart - Player Expected Gains per unit (Hit)")
  for c in 2..9:
    stdout.write &"A{c}   "
    for j in 0..9:
      stdout.write &"{hegs3[c-2][j]: 0.3f} "
    echo()


  printHeader("\nSoft Chart - Player Expected Gains per unit (Double)")
  for c in 2..9:
    stdout.write &"A{c}   "
    for j in 0..9:
      stdout.write &"{degs3[c-2][j]: 0.3f} "
    echo()


  printHeader("\nSoft Chart - Player Strategy (Round 1)")
  for c in 2..9:
    stdout.write &"A{c}   "
    for j in 0..9:
      let ags = [(Stand, segs3[c-2][j]), (Hit, hegs3[c-2][j]), (Double, degs3[c-2][j])]
      let action = bestAction(ags)
      sTable[c-2][j] = action
      stdout.write &"{action:^6} "
    echo()


  # For soft scores (at least one ace) - after round 1 (no doubling or splitting).
  # Based on soft table figures (round 1) with scores of 12 and 21 added.
  # Assumes one ace counted as 11.
  var
    segs4: array[10, array[10, float]]  # Expected gains if stands.
    hegs4: array[10, array[10, float]]  # Expected gains if hits.
  for i in 1..8:
    segs4[i] = segs3[i-1]
    hegs4[i] = hegs3[i-1]

  let sg12 = stand(1, 1)
  let hg12 = hit(1, 1, false)
  for j in 0..9:
    segs4[0][j] += sg12[j]
    hegs4[0][j] += hg12[j]
    segs4[9][j] += sg21[j]
    hegs4[9][j] += hg21[j]

  printHeader("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)")
  for i in 12..21:
    stdout.write &"{i:2}   "
    for j in 0..9:
      var action = Stand
      if hegs4[i-12][j] > segs4[i-12][j]: action = Hit
      sTable2[i-12][j] = action
      stdout.write &"{action:^6} "
    echo()


  # For pairs.

  # Expected gains for each pair (A to 10) & for each dealer up-card.
  var
    segs5: array[10, array[10, float]]  # if stands.
    hegs5: array[10, array[10, float]]  # if hits.
    degs5: array[10, array[10, float]]  # if double.
    pegs5: array[10, array[10, float]]  # if split.
  for c in 1..10:
    let
      sg = stand(c, c)
      hg = hit(c, c, false)
      dg = double(c, c)
      pg = split(c)
    for j in 0..9:
      segs5[c-1][j] += sg[j]
      hegs5[c-1][j] += hg[j]
      degs5[c-1][j] += dg[j]
      pegs5[c-1][j] += pg[j]

  printHeader("\nPairs Chart - Player Expected Gains per unit (Stand)")
  for c in 1..10:
    printPair(c)
    for j in 0..9:
      stdout.write &"{segs5[c-1][j]: 0.3f} "
    echo()

  printHeader("\nPairs Chart - Player Expected Gains per unit (Hit)")
  for c in 1..10:
    printPair(c)
    for j in 0..9:
      stdout.write &"{hegs5[c-1][j]: 0.3f} "
    echo()

  printHeader("\nPairs Chart - Player Expected Gains per unit (Double)")
  for c in 1..10:
    printPair(c)
    for j in 0..9:
      stdout.write &"{degs5[c-1][j]: 0.3f} "
    echo()

  printHeader("\nPairs Chart - Player Expected Gains per unit (Split)")
  for c in 1..10:
    printPair(c)
    for j in 0..9:
      stdout.write &"{pegs5[c-1][j]: 0.3f} "
    echo()

  printHeader("\nPairs Chart - Player Strategy (Round 1)")
  for c in 1..10:
    printPair(c)
    for j in 0..9:
      let ags = [(Stand, segs5[c-1][j]), (Hit, hegs5[c-1][j]),
                 (Double, degs5[c-1][j]), (Split, pegs5[c-1][j])]
      let action = bestAction(ags)
      pTable[c-1][j] = action
      stdout.write &"{action:^6} "
    echo()

  randomize()

  # Do 10 years of simulation.
  for i in 1..10:
    echo &"Simulation for year {i}:"
    simulate(50, 365)

main()
