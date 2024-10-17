import kotlin.random.Random

fun main() {
    while (true) {
        val values = List(6) {
            val rolls = generateSequence { 1 + Random.nextInt(6) }.take(4)
            rolls.sorted().take(3).sum()
        }
        val vsum = values.sum()
        val vcount = values.count { it >= 15 }
        if (vsum < 75 || vcount < 2) continue
        println("The 6 random numbers generated are: $values")
        println("Their sum is $vsum and $vcount of them are >= 15")
        break
    }
}
