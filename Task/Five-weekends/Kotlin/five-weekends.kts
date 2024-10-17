// version 1.0.6

import java.util.*

fun main(args: Array<String>) {
    val calendar = GregorianCalendar(1900, 0, 1)
    val months31 = arrayOf(1, 3, 5, 7, 8, 10, 12)
    val monthsWithFive = mutableListOf<String>()
    val yearsWithNone  = mutableListOf<Int>()
    for (year in 1900..2100) {
        var countInYear = 0 //  counts months in a given year with 5 weekends
        for (month in 1..12) {
            if ((month in months31) && (Calendar.FRIDAY == calendar[Calendar.DAY_OF_WEEK])) {
                countInYear++
                monthsWithFive.add("%02d".format(month) + "-" + year)
            }
            calendar.add(Calendar.MONTH, 1)
        }
        if (countInYear == 0) yearsWithNone.add(year)
    }
    println("There are ${monthsWithFive.size} months with 5 weekends")
    println("The first 5 are ${monthsWithFive.take(5)}")
    println("The final 5 are ${monthsWithFive.takeLast(5)}")
    println()
    println("There are ${yearsWithNone.size} years with no months which have 5 weekends, namely:")
    println(yearsWithNone)
}
