// version 1.1.4-3

import java.time.format.DateTimeFormatter
import java.time.LocalDate
import java.time.temporal.ChronoUnit.DAYS

/* year = 1..  month = 1..13  day = 1..30 */
class FrenchRCDate(val year: Int, val month: Int, val day: Int) {

    init {
        require (year > 0 && month in 1..13)
        if (month < 13) require (day in 1..30)
        else {
            val leap = isLeapYear(year)
            require (day in (if (leap) 1..6 else 1..5))
        }
    }

    override fun toString() =
        if (month < 13) "$day ${months[month - 1]} $year"
        else "${intercal[day - 1]} $year"

    fun toLocalDate(): LocalDate {
        var sumDays = 0L
        for (i in 1 until year) sumDays += if (isLeapYear(i)) 366 else 365
        val dayInYear = (month - 1) * 30 + day - 1
        return introductionDate.plusDays(sumDays + dayInYear)
    }

    companion object {
        /* uses the 'continuous method' for years after 1805 */
        fun isLeapYear(y: Int): Boolean {
            val yy = y + 1
            return (yy % 4 == 0) && (yy % 100 != 0 || yy % 400 == 0)
        }

        fun parse(frcDate: String): FrenchRCDate {
            val splits = frcDate.trim().split(' ')
            if (splits.size == 3) {
                val month = months.indexOf(splits[1]) + 1
                require(month in 1..13)
                val year = splits[2].toIntOrNull() ?: 0
                require(year > 0)
                val monthLength = if (month < 13) 30 else if (isLeapYear(year)) 6 else 5
                val day = splits[0].toIntOrNull() ?: 0
                require(day in 1..monthLength)
                return FrenchRCDate(year, month, day)
            }
            else if (splits.size in 4..5) {
                val yearStr = splits[splits.lastIndex]
                val year = yearStr.toIntOrNull() ?: 0
                require(year > 0)
                val scDay = frcDate.trim().dropLast(yearStr.length + 1)
                val day = intercal.indexOf(scDay) + 1
                val maxDay = if (isLeapYear(year)) 6 else 5
                require (day in 1..maxDay)
                return FrenchRCDate(year, 13, day)
            }
            else throw IllegalArgumentException("Invalid French Republican date")
        }

        /* for convenience we treat 'Sansculottide' as an extra month with 5 or 6 days */
        val months = arrayOf(
            "Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse", "Germinal",
            "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide"
        )

        val intercal = arrayOf(
            "Fête de la vertu", "Fête du génie", "Fête du travail",
            "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"
        )

        val introductionDate = LocalDate.of(1792, 9, 22)
    }
}

fun LocalDate.toFrenchRCDate(): FrenchRCDate {
    val daysDiff  = DAYS.between(FrenchRCDate.introductionDate, this).toInt() + 1
    if (daysDiff <= 0) throw IllegalArgumentException("Date can't be before 22 September 1792")
    var year = 1
    var startDay = 1
    while (true) {
        val endDay = startDay + if (FrenchRCDate.isLeapYear(year)) 365 else 364
        if (daysDiff in startDay..endDay) break
        year++
        startDay = endDay + 1
    }
    val remDays = daysDiff - startDay
    val month  = remDays / 30
    val day = remDays - month * 30
    return FrenchRCDate(year, month + 1, day + 1)
}

fun main(args: Array<String>) {
    val formatter = DateTimeFormatter.ofPattern("d MMMM yyyy")
    val dates = arrayOf("22 September 1792", "20 May 1795", "15 July 1799", "23 September 1803",
                        "31 December 1805", "18 March 1871", "25 August 1944", "19 September 2016",
                        "22 September 2017", "28 September 2017")
    val frcDates = Array<String>(dates.size) { "" }
    for ((i, date) in dates.withIndex()) {
        val thisDate = LocalDate.parse(date, formatter)
        val frcd = thisDate.toFrenchRCDate()
        frcDates[i] = frcd.toString()
        println("${date.padEnd(25)} => $frcd")
    }

    // now process the other way around
    println()
    for (frcDate in frcDates) {
        val thisDate = FrenchRCDate.parse(frcDate)
        val lds = formatter.format(thisDate.toLocalDate())
        println("${frcDate.padEnd(25)} => $lds")
    }
}
