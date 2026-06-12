import algorithm, deques, random, sequtils, strutils

proc riffle(deck: seq[int]; iterations: Positive): seq[int] =
  result = deck

  for _ in 1..iterations:
    let mid = deck.len div 2
    let tenPc = mid div 10
    # Choose a random number within 10% of midpoint.
    let cut = mid - tenPc + rand(2 * tenPc)
    # Split deck into two at cut point.
    var deck1 = result[0..<cut].toDeque
    var deck2 = result[cut..^1].toDeque
    result.setLen(0)
    let fromTop = bool(rand(1))   # Choose to draw from top or bottom.
    while deck1.len > 0 and deck2.len > 0:
      if fromTop:
        result.add deck1.popFirst
        result.add deck2.popFirst
      else:
        result.add deck1.popLast
        result.add deck2.popLast
    # Add any remaining cards to the pile and reverse it.
    if deck1.len > 0: result.add deck1.toSeq
    elif deck2.len > 0: result.add deck2.toSeq
    result.reverse()

proc overhand(deck: seq[int]; iterations: Positive): seq[int] =
  result = deck
  var pile: seq[int]
  let twentyPc = deck.len div 5
  for _ in 1..iterations:
    while result.len > 0:
      let cards = min(result.len, rand(1..twentyPc))
      pile.insert result[0..<cards]
      result.delete(0, cards - 1)
    result = move(pile)

when isMainModule:

  randomize()
  echo "Starting deck:"
  var deck = toSeq(1..20)
  echo deck.join(" ")
  let iterations = 10
  echo "\nRiffle shuffle with $# iterations:".format(iterations)
  echo riffle(deck, iterations).join(" ")
  echo "\nOverhand shuffle with $# iterations:".format(iterations)
  echo overhand(deck, iterations).join(" ")
  echo "\nStandard library shuffle with one iteration:"
  deck.shuffle()  # Shuffles deck in place.
  echo deck.join(" ")
