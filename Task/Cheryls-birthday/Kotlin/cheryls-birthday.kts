// Version 1.2.71

val months = listOf(
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
)

class Birthday(val month: Int, val day: Int) {
    public override fun toString() = "${months[month - 1]} $day"

    public fun monthUniqueIn(bds: List<Birthday>): Boolean {
        return bds.count { this.month == it.month } == 1
    }

    public fun dayUniqueIn(bds: List<Birthday>): Boolean {
        return bds.count { this.day == it.day } == 1
    }

    public fun monthWithUniqueDayIn(bds: List<Birthday>): Boolean {
        return bds.any { (this.month == it.month) && it.dayUniqueIn(bds) }
    }
}

fun main(args: Array<String>) {
    val choices = listOf(
        Birthday(5, 15), Birthday(5, 16), Birthday(5, 19), Birthday(6, 17),
        Birthday(6, 18), Birthday(7, 14), Birthday(7, 16), Birthday(8, 14),
        Birthday(8, 15), Birthday(8, 17)
    )

    // Albert knows the month but doesn't know the day.
    // So the month can't be unique within the choices.
    var filtered = choices.filterNot { it.monthUniqueIn(choices) }

    // Albert also knows that Bernard doesn't know the answer.
    // So the month can't have a unique day.
    filtered = filtered.filterNot { it.monthWithUniqueDayIn(filtered) }

    // Bernard now knows the answer.
    // So the day must be unique within the remaining choices.
    filtered = filtered.filter { it.dayUniqueIn(filtered) }

    // Albert now knows the answer too.
    // So the month must be unique within the remaining choices.
    filtered = filtered.filter { it.monthUniqueIn(filtered) }

    if (filtered.size == 1)
        println("Cheryl's birthday is ${filtered[0]}")
    else
        println("Something went wrong!")
}
