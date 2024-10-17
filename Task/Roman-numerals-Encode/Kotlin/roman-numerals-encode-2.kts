fun Int.toRomanNumeral(): String {
    fun digit(k: Int, unit: String, five: String, ten: String): String {
        return when (k) {
            in 1..3 -> unit.repeat(k)
            4 -> unit + five
            in 5..8 -> five + unit.repeat(k - 5)
            9 -> unit + ten
            else -> throw IllegalArgumentException("$k not in range 1..9")
        }
    }
    return when (this) {
        0 -> ""
        in 1..9 -> digit(this, "I", "V", "X")
        in 10..99 -> digit(this / 10, "X", "L", "C") + (this % 10).toRomanNumeral()
        in 100..999 -> digit(this / 100, "C", "D", "M") + (this % 100).toRomanNumeral()
        in 1000..3999 -> "M" + (this - 1000).toRomanNumeral()
        else -> throw IllegalArgumentException("${this} not in range 0..3999")
    }
}
