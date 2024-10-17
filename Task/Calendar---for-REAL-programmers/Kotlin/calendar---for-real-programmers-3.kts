import java.text.*
import java.util.*
import java.io.PrintStream

internal fun PrintStream.PRINTCALENDAR(YEAR: Int, NCOLS: Byte, LOCALE: Locale?) {
    if (NCOLS < 1 || NCOLS > 12)
        throw IllegalArgumentException("ILLEGAL COLUMN WIDTH.")
    val W = NCOLS * 24
    val NROWS = Math.ceil(12.0 / NCOLS).toInt()

    val DATE = GregorianCalendar(YEAR, 0, 1)
    var OFFS = DATE.get(Calendar.DAY_OF_WEEK) - 1

    val DAYS = DateFormatSymbols(LOCALE).shortWeekdays.slice(1..7).map { it.slice(0..1) }.joinToString(" ", " ")
    val MONS = Array(12) { Array(8) { "" } }
    DateFormatSymbols(LOCALE).months.slice(0..11).forEachIndexed { M, NAME ->
        val LEN = 11 + NAME.length / 2
        val FORMAT = MessageFormat.format("%{0}s%{1}s", LEN, 21 - LEN)
        MONS[M][0] = String.format(FORMAT, NAME, "")
        MONS[M][1] = DAYS
        val DIM = DATE.getActualMaximum(Calendar.DAY_OF_MONTH)
        for (D in 1..42) {
            val ISDAY = D > OFFS && D <= OFFS + DIM
            val ENTRY = if (ISDAY) String.format(" %2s", D - OFFS) else "   "
            if (D % 7 == 1)
                MONS[M][2 + (D - 1) / 7] = ENTRY
            else
                MONS[M][2 + (D - 1) / 7] += ENTRY
        }
        OFFS = (OFFS + DIM) % 7
        DATE.add(Calendar.MONTH, 1)
    }

    printf("%" + (W / 2 + 10) + "s%n", "[SNOOPY PICTURE]")
    printf("%" + (W / 2 + 4) + "s%n%n", YEAR)

    for (R in 0..NROWS - 1) {
        for (I in 0..7) {
            var C = R * NCOLS
            while (C < (R + 1) * NCOLS && C < 12) {
                printf("   %s", MONS[C][I].toUpperCase())  // ORIGINAL CHANGED TO PRINT in UPPER CASE
                C++
            }
            println()
        }
        println()
    }
}

fun main(args: Array<String>) {
    System.out.PRINTCALENDAR(1969, 3, Locale.US)
}
