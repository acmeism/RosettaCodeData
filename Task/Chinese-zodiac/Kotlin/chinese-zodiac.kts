// version 1.1.2

class ChineseZodiac(val year: Int) {
    val stem   : Char
    val branch : Char
    val sName  : String
    val bName  : String
    val element: String
    val animal : String
    val aspect : String
    val cycle  : Int

    private companion object {
        val animals  = listOf("Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
                              "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig")
        val aspects  = listOf("Yang","Yin")
        val elements = listOf("Wood", "Fire", "Earth", "Metal", "Water")
        val stems    = listOf('甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸')
        val branches = listOf('子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥')
        val sNames   = listOf("jiă", "yĭ", "bĭng", "dīng", "wù", "jĭ", "gēng", "xīn", "rén", "gŭi")
        val bNames   = listOf("zĭ", "chŏu", "yín", "măo", "chén", "sì", "wŭ", "wèi", "shēn", "yŏu",  "xū", "hài")
        val fmt      = "%d    %c%c   %-9s  %-7s  %-7s   %-6s %02d/60"
    }

    init {
        val y = year - 4
        val s = y % 10
        val b = y % 12
        stem    = stems[s]
        branch  = branches[b]
        sName   = sNames[s]
        bName   = bNames[b]
        element = elements[s / 2]
        animal  = animals[b]
        aspect  = aspects[s % 2]
        cycle   = y % 60 + 1
    }

    override fun toString() =
        fmt.format(year, stem, branch, sName + "-" + bName, element, animal, aspect, cycle)
}

fun main(args: Array<String>) {
    val years = intArrayOf(1935, 1938, 1968, 1972, 1976, 1984, 2017)
    println("Year  Chinese  Pinyin     Element  Animal   Aspect  Cycle")
    println("----  -------  ---------  -------  -------  ------  -----")
    for (year in years) println(ChineseZodiac(year))
}
