// version 1.1.2

object Lzw {
    /** Compress a string to a list of output symbols. */
    fun compress(uncompressed: String): MutableList<Int> {
        // Build the dictionary.
        var dictSize = 256
        val dictionary = mutableMapOf<String, Int>()
        (0 until dictSize).forEach { dictionary.put(it.toChar().toString(), it)}

        var w = ""
        val result = mutableListOf<Int>()
        for (c in uncompressed) {
            val wc = w + c
            if (dictionary.containsKey(wc))
                w = wc
            else {
                result.add(dictionary[w]!!)
                // Add wc to the dictionary.
                dictionary.put(wc, dictSize++)
                w = c.toString()
            }
        }

        // Output the code for w
        if (!w.isEmpty()) result.add(dictionary[w]!!)
        return result
    }

    /** Decompress a list of output symbols to a string. */
    fun decompress(compressed: MutableList<Int>): String {
        // Build the dictionary.
        var dictSize = 256
        val dictionary = mutableMapOf<Int, String>()
        (0 until dictSize).forEach { dictionary.put(it, it.toChar().toString())}

        var w = compressed.removeAt(0).toChar().toString()
        val result = StringBuilder(w)
        for (k in compressed) {
            var entry: String
            if (dictionary.containsKey(k))
                entry = dictionary[k]!!
            else if (k == dictSize)
                entry = w + w[0]
            else
                throw IllegalArgumentException("Bad compressed k: $k")
            result.append(entry)

            // Add w + entry[0] to the dictionary.
            dictionary.put(dictSize++, w + entry[0])
            w = entry
        }
        return result.toString()
    }
}

fun main(args: Array<String>) {
    val compressed = Lzw.compress("TOBEORNOTTOBEORTOBEORNOT")
    println(compressed)
    val decompressed = Lzw.decompress(compressed)
    println(decompressed)
}
