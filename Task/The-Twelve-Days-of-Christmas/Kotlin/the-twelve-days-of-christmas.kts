enum class Day {
    first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth;
    val header = "On the " + this + " day of Christmas, my true love sent to me\n\t"
}

fun main(x: Array<String>) {
    val gifts = listOf("A partridge in a pear tree",
                       "Two turtle doves and",
                       "Three french hens",
                       "Four calling birds",
                       "Five golden rings",
                       "Six geese a-laying",
                       "Seven swans a-swimming",
                       "Eight maids a-milking",
                       "Nine ladies dancing",
                       "Ten lords a-leaping",
                       "Eleven pipers piping",
                       "Twelve drummers drumming")

    Day.values().forEachIndexed { i, d -> println(d.header + gifts.slice(0..i).asReversed().joinToString("\n\t")) }
}
