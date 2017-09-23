// version 1.1.3

val text =
    "In olden times when wishing still helped one, there lived a king " +
    "whose daughters were all beautiful, but the youngest was so beautiful " +
    "that the sun itself, which has seen so much, was astonished whenever " +
    "it shone in her face.  Close by the king's castle lay a great dark " +
    "forest, and under an old lime tree in the forest was a well, and when " +
    "the day was very warm, the king's child went out into the forest and " +
    "sat down by the side of the cool fountain, and when she was bored she " +
    "took a golden ball, and threw it up on high and caught it, and this " +
    "ball was her favorite plaything."

fun greedyWordwrap(text: String, lineWidth: Int): String {
    val words = text.split(' ')
    val sb = StringBuilder(words[0])
    var spaceLeft = lineWidth - words[0].length
    for (word in words.drop(1)) {
        val len = word.length
        if (len + 1 > spaceLeft) {
            sb.append("\n").append(word)
            spaceLeft = lineWidth - len
        }
        else {
            sb.append(" ").append(word)
            spaceLeft -= (len + 1)
        }
    }
    return sb.toString()
}

fun main(args: Array<String>) {
    println("Greedy algorithm - wrapped at 72:")
    println(greedyWordwrap(text, 72))
    println("\nGreedy algorithm - wrapped at 80:")
    println(greedyWordwrap(text, 80))
}
