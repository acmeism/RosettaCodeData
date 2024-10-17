object ABC_block_checker {
    fun run() {
        println("\"\": " + blocks.canMakeWord(""))
        for (w in words) println("$w: " + blocks.canMakeWord(w))
    }

    private fun Array<String>.swap(i: Int, j: Int) {
        val tmp = this[i]
        this[i] = this[j]
        this[j] = tmp
    }

    private fun Array<String>.canMakeWord(word: String): Boolean {
        if (word.isEmpty())
            return true

        val c = word.first().toUpperCase()
        var i = 0
        forEach { b ->
            if (b.first().toUpperCase() == c || b[1].toUpperCase() == c) {
                swap(0, i)
                if (drop(1).toTypedArray().canMakeWord(word.substring(1)))
                    return true
                swap(0, i)
            }
            i++
        }

        return false
    }

    private val blocks = arrayOf(
        "BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
        "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"
    )
    private val words = arrayOf("A", "BARK", "book", "treat", "COMMON", "SQuAd", "CONFUSE")
}

fun main(args: Array<String>) = ABC_block_checker.run()
