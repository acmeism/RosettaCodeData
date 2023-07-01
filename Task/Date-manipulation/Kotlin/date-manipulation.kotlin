// version 1.0.6

import java.text.SimpleDateFormat
import java.util.*

fun main(args: Array<String>) {
    val dts  = "March 7 2009 7:30pm EST"
    val sdf  = SimpleDateFormat("MMMM d yyyy h:mma z")
    val dt   = sdf.parse(dts)
    val cal  = GregorianCalendar(TimeZone.getTimeZone("EST"))  // stay with EST
    cal.time = dt
    cal.add(Calendar.HOUR_OF_DAY, 12) // add 12 hours
    val fmt = "%tB %1\$td %1\$tY %1\$tl:%1\$tM%1\$tp %1\$tZ"
    println(fmt.format(cal)) // display new time

    // display time now in Mountain Standard Time which is 2 hours earlier than EST
    cal.timeZone = TimeZone.getTimeZone("MST")
    println(fmt.format(cal))
}
