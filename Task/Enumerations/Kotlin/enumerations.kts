// version 1.0.5-2

enum class Animals {
    CAT, DOG, ZEBRA
}

enum class Dogs(val id: Int) {
    BULLDOG(1), TERRIER(2), WOLFHOUND(4)
}

fun main(args: Array<String>) {
    for (value in Animals.values()) println("${value.name.padEnd(5)} : ${value.ordinal}")
    println()
    for (value in Dogs.values()) println("${value.name.padEnd(9)} : ${value.id}")
}
