import "random" for Random
import "./fmt" for Fmt

var R = 82 // ASCII 'R'
var B = 66 // ASCII 'B'

// Create pack, half red, half black and shuffle it.
var pack = [0] * 52
for (i in 0..25) {
    pack[i] = R
    pack[26+i] = B
}
var rand = Random.new()
rand.shuffle(pack)

// Deal from pack into 3 stacks.
var red = []
var black = []
var discard = []
var i = 0
while (i < 51) {
    if (pack[i] == B) {
        black.add(pack[i+1])
    } else {
        red.add(pack[i+1])
    }
    discard.add(pack[i])
    i = i + 2
}
var lr = red.count
var lb = black.count
var ld = discard.count
System.print("After dealing the cards the state of the stacks is:")
Fmt.print("  Red    : $2d cards -> $c", lr, red)
Fmt.print("  Black  : $2d cards -> $c", lb, black)
Fmt.print("  Discard: $2d cards -> $c", ld, discard)

// Swap the same, random, number of cards between the red and black stacks.
var min = (lr < lb) ? lr : lb
var n = rand.int(1, min + 1)
var rp = [0] * lr
var bp = [0] * lb
for (i in 0...lr) rp[i] = i
for (i in 0...lb) bp[i] = i
rand.shuffle(rp)
rand.shuffle(bp)
rp = rp[0...n]
bp = bp[0...n]
System.print("\n%(n) card(s) are to be swapped.\n")
System.print("The respective zero-based indices of the cards(s) to be swapped are:")
Fmt.print("  Red    : $2d", rp)
Fmt.print("  Black  : $2d", bp)
for (i in 0...n) {
    var t = red[rp[i]]
    red[rp[i]] = black[bp[i]]
    black[bp[i]] = t
}
System.print("\nAfter swapping, the state of the red and black stacks is:")
Fmt.print("  Red    : $c", red)
Fmt.print("  Black  : $c", black)

// Check that the number of black cards in the black stack equals
// the number of red cards in the red stack.
var rcount = red.count   { |c| c == R }
var bcount = black.count { |c| c == B }
System.print("\nThe number of red cards in the red stack     = %(rcount)")
System.print("The number of black cards in the black stack = %(bcount)")
if (rcount == bcount) {
    System.print("So the asssertion is correct!")
} else {
    System.print("So the asssertion is incorrect!")
}
