import java.util.Calendar
import java.util.GregorianCalendar

enum class Season {
    Chaos, Discord, Confusion, Bureaucracy, Aftermath;
    companion object { fun from(i: Int) = values()[i / 73] }
}
enum class Weekday {
    Sweetmorn, Boomtime, Pungenday, Prickle_Prickle, Setting_Orange;
    companion object { fun from(i: Int) = values()[i % 5] }
}
enum class Apostle {
    Mungday, Mojoday, Syaday, Zaraday, Maladay;
    companion object { fun from(i: Int) = values()[i / 73] }
}
enum class Holiday {
    Chaoflux, Discoflux, Confuflux, Bureflux, Afflux;
    companion object { fun from(i: Int) = values()[i / 73] }
}

fun GregorianCalendar.discordianDate(): String {
    val y = get(Calendar.YEAR)
    val yold = y + 1166

    var dayOfYear = get(Calendar.DAY_OF_YEAR)
    if (isLeapYear(y)) {
        if (dayOfYear == 60)
            return "St. Tib's Day, in the YOLD " + yold
        else if (dayOfYear > 60)
            dayOfYear--
    }

    val seasonDay = --dayOfYear % 73 + 1
    return when (seasonDay) {
        5 -> "" + Apostle.from(dayOfYear) + ", in the YOLD " + yold
        50 -> "" + Holiday.from(dayOfYear) + ", in the YOLD " + yold
        else -> "" + Weekday.from(dayOfYear) + ", day " + seasonDay + " of " + Season.from(dayOfYear) + " in the YOLD " + yold
    }
}

internal fun test(y: Int, m: Int, d: Int, result: String) {
    assert(GregorianCalendar(y, m, d).discordianDate() == result)
}

fun main(args: Array<String>) {
    println(GregorianCalendar().discordianDate())

    test(2010, 6, 22, "Pungenday, day 57 of Confusion in the YOLD 3176")
    test(2012, 1, 28, "Prickle-Prickle, day 59 of Chaos in the YOLD 3178")
    test(2012, 1, 29, "St. Tib's Day, in the YOLD 3178")
    test(2012, 2, 1, "Setting Orange, day 60 of Chaos in the YOLD 3178")
    test(2010, 0, 5, "Mungday, in the YOLD 3176")
    test(2011, 4, 3, "Discoflux, in the YOLD 3177")
    test(2015, 9, 19, "Boomtime, day 73 of Bureaucracy in the YOLD 3181")
}
