// version 1.0.6

val r = Regex("""\s+""")

fun separateHouseNumber(address: String): Pair<String, String> {
    val street: String
    val house:  String
    val len    = address.length
    val splits = address.split(r)
    val size   = splits.size
    val last   = splits[size - 1]
    val penult = splits[size - 2]
    if (last[0] in '0'..'9') {
        if (size > 2 && penult[0] in '0'..'9' && !penult.startsWith("194")) house = penult + " " + last
        else house = last
    }
    else if (size > 2) house = penult + " " + last
    else house = ""
    street = address.take(len - house.length).trimEnd()
    return Pair(street, house)
}

fun main(args: Array<String>) {
    val addresses = arrayOf(
        "Plataanstraat 5",
        "Straat 12",
        "Straat 12 II",
        "Dr. J. Straat   12",
        "Dr. J. Straat 12 a",
        "Dr. J. Straat 12-14",
        "Laan 1940 - 1945 37",
        "Plein 1940 2",
        "1213-laan 11",
        "16 april 1944 Pad 1",
        "1e Kruisweg 36",
        "Laan 1940-'45 66",
        "Laan '40-'45",
        "Langeloërduinen 3 46",
        "Marienwaerdt 2e Dreef 2",
        "Provincialeweg N205 1",
        "Rivium 2e Straat 59.",
        "Nieuwe gracht 20rd",
        "Nieuwe gracht 20rd 2",
        "Nieuwe gracht 20zw /2",
        "Nieuwe gracht 20zw/3",
        "Nieuwe gracht 20 zw/4",
        "Bahnhofstr. 4",
        "Wertstr. 10",
        "Lindenhof 1",
        "Nordesch 20",
        "Weilstr. 6",
        "Harthauer Weg 2",
        "Mainaustr. 49",
        "August-Horch-Str. 3",
        "Marktplatz 31",
        "Schmidener Weg 3",
        "Karl-Weysser-Str. 6"
    )
    println("Street                   House Number")
    println("---------------------    ------------")
    for (address in addresses) {
        val (street, house) = separateHouseNumber(address)
        println("${street.padEnd(22)}   ${if (house != "") house else "(none)"}")
    }
}
