// version 1.1.2

import java.util.Calendar
import java.util.GregorianCalendar

val holidayOffsets = listOf(
    "Easter" to 0,
    "Ascension" to 39,
    "Pentecost" to 49,
    "Trinity" to 56,
    "C/Christi" to 60
)

fun String.padCenter(n: Int): String {
    val len = this.length
    if (n <= len) return this
    return this.padStart((n + len) / 2).padEnd(n)
}

fun calculateEaster(year: Int): GregorianCalendar {
    val a = year % 19
    val b = year / 100
    val c = year % 100
    val d = b / 4
    val e = b % 4
    val f = (b + 8) / 25
    val g = (b - f + 1) / 3
    val h = (19 * a + b - d - g + 15) % 30
    val i = c / 4
    val k = c % 4
    val l = (32 + 2 * e + 2 * i - h - k) % 7
    val m = (a + 11 * h + 22 * l) / 451
    val n = h + l - 7 * m + 114
    val month = n / 31 - 1  // months indexed from 0
    val day = (n % 31) + 1
    return GregorianCalendar(year, month, day)
}

fun outputHolidays(year: Int) {
    val date = calculateEaster(year)
    print("%4d  ".format(year))
    var po = 0
    for ((h, o) in holidayOffsets) {
        date.add(Calendar.DATE, o - po)
        po = o
        print("${"%1\$td %1\$tb".format(date).padCenter(h.length)}  ")
    }
    println()
}

fun main(args: Array<String>) {
    println("Year  Easter  Ascension  Pentecost  Trinity  C/Christi")
    println(" CE   Sunday  Thursday    Sunday    Sunday   Thursday ")
    println("----  ------  ---------  ---------  -------  ---------")
    for (year in 400..2100 step 100) outputHolidays(year)
    println()
    for (year in 2010..2020) outputHolidays(year)
}
