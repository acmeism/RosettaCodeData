// version 1.0.6

import java.util.*

fun main(args: Array<String>) {
    print("Enter a year : ")
    val year = readLine()!!.toInt()

    println("The last Fridays of each month in $year are as follows:")
    val calendar = GregorianCalendar(year, 0, 31)
    for (month in 1..12) {
        val daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
        var offset = calendar[Calendar.DAY_OF_WEEK] - Calendar.FRIDAY
        if (offset < 0) offset += 7
        val lastFriday = daysInMonth - offset
        println("$year-" + "%02d-".format(month) + "%02d".format(lastFriday))
        if (month < 12) {
            calendar.add(Calendar.DAY_OF_MONTH, 1)
            calendar.add(Calendar.MONTH, 1)
            calendar.add(Calendar.DAY_OF_MONTH, -1)
        }
    }
}
