// version 1.1.4-3

val r = Regex("""(\.[0-9]+|[1-9]([0-9]+)?(\.[0-9]+)?)""")

fun String.commatize(startIndex: Int = 0, period: Int = 3, sep: String = ","): String {
    if ((startIndex !in 0 until this.length) || period < 1 || sep == "") return this
    val m = r.find(this, startIndex)
    if (m == null) return this
    val splits = m.value.split('.')
    var ip = splits[0]
    if (ip.length > period) {
        val sb = StringBuilder(ip.reversed())
        for (i in (ip.length - 1) / period * period downTo period step period) {
            sb.insert(i, sep)
        }
        ip = sb.toString().reversed()
    }
    if ('.' in m.value) {
        var dp = splits[1]
        if (dp.length > period) {
            val sb2 = StringBuilder(dp)
            for (i in (dp.length - 1) / period * period downTo period step period) {
                sb2.insert(i, sep)
            }
            dp = sb2.toString()
        }
        ip += "." + dp
    }
    return this.take(startIndex) + this.drop(startIndex).replaceFirst(m.value, ip)
}

fun main(args: Array<String>) {
    val tests = arrayOf(
        "123456789.123456789",
        ".123456789",
        "57256.1D-4",
        "pi=3.14159265358979323846264338327950288419716939937510582097494459231",
        "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
        "-in Aus$+1411.8millions",
        "===US$0017440 millions=== (in 2000 dollars)",
        "123.e8000 is pretty big.",
        "The land area of the earth is 57268900(29% of the surface) square miles.",
        "Ain't no numbers in this here words, nohow, no way, Jose.",
        "James was never known as 0000000007",
        "Arthur Eddington wrote: I believe there are " +
        "15747724136275002577605653961181555468044717914527116709366231425076185631031296" +
        " protons in the universe.",
        "   $-140000±100 millions.",
        "6/9/1946 was a good year for some."
    )

    println(tests[0].commatize(period = 2, sep = "*"))
    println(tests[1].commatize(period = 3, sep = "-"))
    println(tests[2].commatize(period = 4, sep = "__"))
    println(tests[3].commatize(period = 5, sep = " "))
    println(tests[4].commatize(sep = "."))
    for (test in tests.drop(5)) println(test.commatize())
}
