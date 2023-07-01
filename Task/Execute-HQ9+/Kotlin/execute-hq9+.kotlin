// version 1.1.3

fun hq9plus(code: String) {
    var acc = 0
    val sb = StringBuilder()
    for (c in code) {
        sb.append(
            when (c) {
                'h', 'H' -> "Hello, world!\n"
                'q', 'Q' -> code + "\n"
                '9'-> {
                    val sb2 = StringBuilder()
                    for (i in 99 downTo 1) {
                        val s = if (i > 1) "s" else ""
                        sb2.append("$i bottle$s of beer on the wall\n")
                        sb2.append("$i bottle$s of beer\n")
                        sb2.append("Take one down, pass it around\n")
                    }
                    sb2.append("No more bottles of beer on the wall!\n")
                    sb2.toString()
                 }
                '+'  -> { acc++; "" }  // yeah, it's weird!
                else -> throw IllegalArgumentException("Code contains illegal operation '$c'")
            }
        )
    }
    println(sb)
}

fun main(args: Array<String>) {
    val code = args[0]  // pass in code as command line argument (using hq9+)
    hq9plus(code)
}
