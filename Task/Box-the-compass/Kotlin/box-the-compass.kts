// version 1.1.2

fun expand(cp: String): String {
    val sb = StringBuilder()
    for (c in cp) {
        sb.append(when (c) {
            'N'  -> "north"
            'E'  -> "east"
            'S'  -> "south"
            'W'  -> "west"
            'b'  -> " by "
            else -> "-"
        })
    }
    return sb.toString().capitalize()
}

fun main(args: Array<String>) {
    val cp = arrayOf(
        "N", "NbE", "N-NE", "NEbN", "NE", "NEbE", "E-NE", "EbN",
        "E", "EbS", "E-SE", "SEbE", "SE", "SEbS", "S-SE", "SbE",
        "S", "SbW", "S-SW", "SWbS", "SW", "SWbW", "W-SW", "WbS",
        "W", "WbN", "W-NW", "NWbW", "NW", "NWbN", "N-NW", "NbW"
    )
    println("Index  Degrees  Compass point")
    println("-----  -------  -------------")
    val f = "%2d     %6.2f   %s"
    for (i in 0..32) {
        val index  = i % 32
        var heading = i * 11.25
        when (i % 3) {
            1 -> heading += 5.62
            2 -> heading -= 5.62
        }
        println(f.format(index + 1, heading, expand(cp[index])))
    }
}
