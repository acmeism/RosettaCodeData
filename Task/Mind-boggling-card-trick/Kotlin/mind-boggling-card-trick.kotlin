// Version 1.2.61

import java.util.Random

fun main(args: Array<String>) {
    // Create pack, half red, half black and shuffle it.
    val pack = MutableList(52) { if (it < 26) 'R' else 'B' }
    pack.shuffle()

    // Deal from pack into 3 stacks.
    val red = mutableListOf<Char>()
    val black = mutableListOf<Char>()
    val discard = mutableListOf<Char>()
    for (i in 0 until 52 step 2) {
        when (pack[i]) {
            'B' -> black.add(pack[i + 1])
            'R' -> red.add(pack[i + 1])
        }
        discard.add(pack[i])
    }
    val sr = red.size
    val sb = black.size
    val sd = discard.size
    println("After dealing the cards the state of the stacks is:")
    System.out.printf("  Red    : %2d cards -> %s\n", sr, red)
    System.out.printf("  Black  : %2d cards -> %s\n", sb, black)
    System.out.printf("  Discard: %2d cards -> %s\n", sd, discard)

    // Swap the same, random, number of cards between the red and black stacks.
    val rand = Random()
    val min = minOf(sr, sb)
    val n = 1 + rand.nextInt(min)
    var rp = MutableList(sr) { it }.shuffled().subList(0, n)
    var bp = MutableList(sb) { it }.shuffled().subList(0, n)
    println("\n$n card(s) are to be swapped\n")
    println("The respective zero-based indices of the cards(s) to be swapped are:")
    println("  Red    : $rp")
    println("  Black  : $bp")
    for (i in 0 until n) {
        val temp = red[rp[i]]
        red[rp[i]] = black[bp[i]]
        black[bp[i]] = temp
    }
    println("\nAfter swapping, the state of the red and black stacks is:")
    println("  Red    : $red")
    println("  Black  : $black")

    // Check that the number of black cards in the black stack equals
    // the number of red cards in the red stack.
    var rcount = 0
    var bcount = 0
    for (c in red) if (c == 'R') rcount++
    for (c in black) if (c == 'B') bcount++
    println("\nThe number of red cards in the red stack     = $rcount")
    println("The number of black cards in the black stack = $bcount")
    if (rcount == bcount) {
        println("So the asssertion is correct!")
    }
    else {
        println("So the asssertion is incorrect!")
    }
}
