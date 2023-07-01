import random, sequtils, strformat, strutils

type Color {.pure.} = enum Red = "R", Black = "B"

proc `$`(s: seq[Color]): string = s.join(" ")

# Create pack, half red, half black and shuffle it.
var pack = newSeq[Color](52)
for i in 0..51: pack[i] = Color(i < 26)
pack.shuffle()

# Deal from pack into 3 stacks.
var red, black, others: seq[Color]
for i in countup(0, 51, 2):
  case pack[i]
    of Red: red.add pack[i + 1]
    of Black: black.add pack[i + 1]
  others.add pack[i]
echo "After dealing the cards the state of the stacks is:"
echo &"  Red:     {red.len:>2} cards -> {red}"
echo &"  Black:   {black.len:>2} cards -> {black}"
echo &"  Discard: {others.len:>2} cards -> {others}"

# Swap the same, random, number of cards between the red and black stacks.
let m = min(red.len, black.len)
let n = rand(1..m)
var rp = toSeq(0..red.high)
rp.shuffle()
rp.setLen(n)
var bp = toSeq(0..black.high)
bp.shuffle()
bp.setLen(n)
echo &"\n{n} card(s) are to be swapped.\n"
echo "The respective zero-based indices of the cards(s) to be swapped are:"
echo "  Red    : ", rp.join(" ")
echo "  Black  : ", bp.join(" ")
for i in 0..<n:
  swap red[rp[i]], black[bp[i]]
echo "\nAfter swapping, the state of the red and black stacks is:"
echo "  Red    : ", red
echo "  Black  : ", black

# Check that the number of black cards in the black stack equals
# the number of red cards in the red stack.
let rcount = red.count(Red)
let bcount = black.count(Black)
echo ""
echo "The number of red cards in the red stack is ", rcount
echo "The number of black cards in the black stack is ", bcount
if rcount == bcount:
  echo "So the asssertion is correct."
else:
  echo "So the asssertion is incorrect."
