// version 1.0.6

import java.util.*

fun main(args: Array<String>) {
    println("Christmas day in the following years falls on a Sunday:\n")
    val calendar = GregorianCalendar(2008, Calendar.DECEMBER, 25)
    for (year in 2008..2121) {
        if (Calendar.SUNDAY == calendar[Calendar.DAY_OF_WEEK]) println(year)
        calendar.add(Calendar.YEAR, 1)
    }
}
