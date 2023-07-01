import std/[algorithm, sequtils, sets, strformat]
import itertools

type Die = object
  name: string
  faces: seq[int]


####################################################################################################
# Die functions.


func `$`(die: Die): string =
  ## Return the string representation of a Die.
  &"({die.name}: {($die.faces)[1..^1]})"


func cmp(die1, die2: Die): int =
  ## Compare two dice returning 1, -1 or 0 for operators >, < ==.
  var tot: array[3, int]
  for d in product(die1.faces, die2.faces):
    inc tot[1 + ord(d[1] < d[0]) - ord(d[0] < d[1])]
  result = ord(tot[0] < tot[2]) - ord(tot[2] < tot[0])


func verboseCmp(die1, die2: Die): string =
  ## Compare two dice returning a string.
  var win1, win2 = 0
  for (d1, d2) in product(die1.faces, die2.faces):
    inc win1, ord(d1 > d2)
    inc win2, ord(d2 > d1)
  result = if win1 > win2: &"{die1.name} > {die2.name}"
           elif win1 < win2: &"{die1.name} < {die2.name}"
           else: &"{die1.name} = {die2.name}"


func `>`(die1, die2: Die): bool = cmp(die1, die2) > 0
func `<=`(die1, die2: Die): bool = cmp(die1, die2) <= 0


####################################################################################################
# Added a permutation iterator as that of "itertools" doesn't allow to specify the length.


iterator permutations[T](values: openArray[T]; r: int): seq[T] {.closure} =
  ## Yield permutations of length "r" with elements taken from "values".
  let n = values.len
  if r > n: return
  var indices = toSeq(0..<n)
  var cycles = toSeq(countdown(n, n - r + 1))
  var perm = values[0..<r]
  yield perm
  if n == 0: return
  while true:
    var exit = true
    for i in countdown(r - 1, 0):
      dec cycles[i]
      if cycles[i] == 0:
        discard indices.rotateLeft(i..indices.high, 1)
        cycles[i] = n - i
      else:
        let j = cycles[i]
        swap indices[i], indices[^j]
        for iperm, ivalues in indices[0..<r]:
          perm[iperm] = values[ivalues]
        yield perm
        exit = false
        break
    if exit: return


####################################################################################################
# Dice functions.


func isNonTrans(dice: openArray[Die]): bool =
  ## Return true if ordering of die in dice is non-transitive.
  for i in 1..dice.high:
    if dice[i] <= dice[i-1]: return false
  result = dice[0] > dice[^1]


func findNonTrans(allDice: openArray[Die]; n = 3): seq[seq[Die]] =
  ## Return the list of non-transitive dice.
  for perm in permutations(allDice, n):
    if perm.isNontrans:
      result.add perm


proc possibleDice(sides, maxval: Positive): seq[Die] =
  ## Return the list of possible dice with given number of sides and maximum value.

  echo &"All possible 1..{maxval} {sides}-sided dice."
  var dice: seq[Die]
  var n = 1
  for faces in product(toSeq(1..maxval), repeat = sides):
    dice.add Die(name: &"D{n}", faces: faces)
    inc n
  echo &"  Created {dice.len} dice."
  echo "  Remove duplicate with same bag of numbers on different faces."
  var found: HashSet[seq[int]]
  for d in dice:
    let count = sorted(d.faces)
    if count notin found:
      found.incl count
      result.add d
  echo &"   Return {result.len} filtered dice."


func verboseDiceCmp(dice: openArray[Die]): string =
  ## Return the verbose comparison of dice.
  for i in 1..dice.high:
    result.add verboseCmp(dice[i-1], dice[i]) & ", "
  result.add verboseCmp(dice[0], dice[^1])


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  let dice = possibleDice(sides = 4, maxval = 4)
  for n in [3, 4]:
    let nonTrans = dice.findNonTrans(n)
    echo &"\n  Non-transitive length-{n} combinations found: {nonTrans.len}."
    for list in nonTrans:
      echo ""
      for i, die in list:
        echo "    ", if i == 0: '[' else: ' ', die, if i == list.high: "]" else: ","
    if nonTrans.len != 0:
      echo &"\n  More verbose comparison of last non-transitive result:"
      echo "  ", verboseDiceCmp(nonTrans[^1])
    echo "\n  ===="
