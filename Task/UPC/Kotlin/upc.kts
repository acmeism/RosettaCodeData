val LEFT_DIGITS = mapOf(
    "   ## #" to 0,
    "  ##  #" to 1,
    "  #  ##" to 2,
    " #### #" to 3,
    " #   ##" to 4,
    " ##   #" to 5,
    " # ####" to 6,
    " ### ##" to 7,
    " ## ###" to 8,
    "   # ##" to 9
)
val RIGHT_DIGITS = LEFT_DIGITS.mapKeys {
    it.key.replace(' ', 's').replace('#', ' ').replace('s', '#')
}

const val END_SENTINEL = "# #"
const val MID_SENTINEL = " # # "

fun decodeUPC(input: String) {
    fun decode(candidate: String): Pair<Boolean, List<Int>> {
        var pos = 0
        var part = candidate.slice(pos until pos + END_SENTINEL.length)
        if (part == END_SENTINEL) {
            pos += END_SENTINEL.length
        } else {
            return Pair(false, emptyList())
        }

        val output = mutableListOf<Int>()
        for (i in 0 until 6) {
            part = candidate.slice(pos until pos + 7)
            pos += 7

            if (LEFT_DIGITS.containsKey(part)) {
                output.add(LEFT_DIGITS.getOrDefault(part, -1))
            } else {
                return Pair(false, output.toList())
            }
        }

        part = candidate.slice(pos until pos + MID_SENTINEL.length)
        if (part == MID_SENTINEL) {
            pos += MID_SENTINEL.length
        } else {
            return Pair(false, output.toList())
        }

        for (i in 0 until 6) {
            part = candidate.slice(pos until pos + 7)
            pos += 7

            if (RIGHT_DIGITS.containsKey(part)) {
                output.add(RIGHT_DIGITS.getOrDefault(part, -1))
            } else {
                return Pair(false, output.toList())
            }
        }

        part = candidate.slice(pos until pos + END_SENTINEL.length)
        if (part == END_SENTINEL) {
            pos += END_SENTINEL.length
        } else {
            return Pair(false, output.toList())
        }

        val sum = output.mapIndexed { i, v -> if (i % 2 == 0) v * 3 else v }.sum()
        return Pair(sum % 10 == 0, output.toList())
    }

    val candidate = input.trim()

    var out = decode(candidate)
    if (out.first) {
        println(out.second)
    } else {
        out = decode(candidate.reversed())
        if (out.first) {
            print(out.second)
            println(" Upside down")
        } else {
            if (out.second.size == 12) {
                println("Invalid checksum")
            } else {
                println("Invalid digit(s)")
            }
        }
    }

}

fun main() {
    val barcodes = listOf(
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    )

    for (barcode in barcodes) {
        decodeUPC(barcode)
    }
}
