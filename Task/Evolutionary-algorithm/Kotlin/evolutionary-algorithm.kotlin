import java.util.*

val target = "METHINKS IT IS LIKE A WEASEL"
val validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "

val random = Random()

fun randomChar() = validChars[random.nextInt(validChars.length)]
fun hammingDistance(s1: String, s2: String) =
        s1.zip(s2).map { if (it.first == it.second) 0 else 1 }.sum()

fun fitness(s1: String) = target.length - hammingDistance(s1, target)

fun mutate(s1: String, mutationRate: Double) =
        s1.map { if (random.nextDouble() > mutationRate) it else randomChar() }
                .joinToString(separator = "")

fun main(args: Array<String>) {
    val initialString = (0 until target.length).map { randomChar() }.joinToString(separator = "")

    println(initialString)
    println(mutate(initialString, 0.2))

    val mutationRate = 0.05
    val childrenPerGen = 50

    var i = 0
    var currVal = initialString
    while (currVal != target) {
        i += 1
        currVal = (0..childrenPerGen).map { mutate(currVal, mutationRate) }.maxBy { fitness(it) }!!
    }
    println("Evolution found target after $i generations")
}
