// version 1.2.10

import java.util.Random

/**
 * Extension function on any list that will return a random element from index 0
 * to the last index
 */
fun <E> List<E>.getRandomElement() = this[Random().nextInt(this.size)]

/**
 * Extension function on any list that will return a list of unique random picks
 * from the list. If the specified number of elements you want is larger than the
 * number of elements in the list it returns null
 */
fun <E> List<E>.getRandomElements(numberOfElements: Int): List<E>? {
    if (numberOfElements > this.size) {
        return null
    }
    return this.shuffled().take(numberOfElements)
}

fun main(args: Array<String>) {
    val list = listOf(1, 16, 3, 7, 17, 24, 34, 23, 11, 2)
    println("The list consists of the following numbers:\n${list}")

    // notice we can call our extension functions as if they were regular member functions of List
    println("\nA randomly selected element from the list is ${list.getRandomElement()}")
    println("\nA random sequence of 5 elements from the list is ${list.getRandomElements(5)}")
}
