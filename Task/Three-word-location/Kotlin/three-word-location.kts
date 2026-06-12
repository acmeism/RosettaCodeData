fun toWord(w: Long): String {
    return "W%05d".format(w)
}

fun fromWord(ws: String): Long {
    return ws.substring(1).toUInt().toLong()
}

fun main() {
    println("Starting figures:")
    var lat = 28.3852
    var lon = -81.5638
    println("  latitude = %.4f, longitude = %.4f".format(lat, lon))
    println()

    // convert lat and lon to positive integers
    var ilat = (lat * 10000 + 900000).toLong()
    var ilon = (lon * 10000 + 1800000).toLong()

    // build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
    var latlon = (ilat shl 22) + ilon

    // isolate relevant bits
    var w1 = (latlon shr 28) and 0x7fff
    var w2 = (latlon shr 14) and 0x3fff
    var w3 = latlon and 0x3fff

    // convert to word format
    val w1s = toWord(w1)
    val w2s = toWord(w2)
    val w3s = toWord(w3)

    // and print the results
    println("Three word location is:")
    println("  $w1s $w2s $w3s")
    println()

    /* now reverse the procedure */
    w1 = fromWord(w1s)
    w2 = fromWord(w2s)
    w3 = fromWord(w3s)

    latlon = (w1 shl 28) or (w2 shl 14) or w3
    ilat = latlon shr 22
    ilon = latlon and 0x3fffff
    lat = (ilat - 900000).toDouble() / 10000
    lon = (ilon - 1800000).toDouble() / 10000

    // and print the results
    println("After reversing the procedure:")
    println("  latitude = %.4f, longitude = %.4f".format(lat, lon))
}
