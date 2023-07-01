# Import "random" to get random numbers and "algorithm" to get sorting functions for arrays.
import random, algorithm

randomize()

proc diceFourRolls(): array[4, int] =
  ## Generates 4 random values between 1 and 6.
  for i in 0 .. 3:
    result[i] = rand(1..6)

proc sumRolls(rolls: array[4, int]): int =
  ## Save the sum of the 3 highest values rolled.
  var sorted = rolls
  sorted.sort()
  # By sorting first and then starting the iteration on 1 instead of 0, the lowest number is discarded even if it is repeated.
  for i in 1 .. 3:
    result += sorted[i]

func twoFifteens(attr: var array[6, int]): bool =
  attr.sort()
  # Sorting implies than the second to last number is lesser than or equal to the last.
  if attr[4] < 15: false else: true

var sixAttr: array[6, int]

while true:
  var sumAttr = 0
  for i in 0 .. 5:
    sixAttr[i] = sumRolls(diceFourRolls())
    sumAttr += sixAttr[i]
  echo "The roll sums are, in order: ", sixAttr, ", which adds to ", sumAttr
  if not twoFifteens(sixAttr) or sumAttr < 75: echo "Not good enough. Rerolling..."
  else: break
