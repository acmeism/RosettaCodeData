// version 1.2.0

import java.util.Random

val rand = Random(6321L) // generates short repeatable sequence
var position = 0

fun step(): Boolean {
    val r = rand.nextBoolean()
    if (r)
        println("Climbed up to ${++position}")
    else
        println("Fell down to ${--position}")
    return r
}

fun stepUp() {
    while (!step()) stepUp()
}

fun main(args: Array<String>) {
    stepUp()
}
