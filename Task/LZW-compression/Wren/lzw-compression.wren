class LZW {
    /* Compress a string to a list of output symbols. */
    static compress(uncompressed) {
        // Build the dictionary.
        var dictSize = 256
        var dictionary = {}
        for (i in 0...dictSize) dictionary[String.fromByte(i)] = i
        var w = ""
        var result = []
        for (c in uncompressed.bytes) {
            var cs = String.fromByte(c)
            var wc = w + cs
            if (dictionary.containsKey(wc)) {
                w = wc
            } else {
                result.add(dictionary[w])
                // Add wc to the dictionary.
                dictionary[wc] = dictSize
                dictSize = dictSize + 1
                w = cs
            }
        }

        // Output the code for w
        if (w != "") result.add(dictionary[w])
        return result
    }

    /* Decompress a list of output symbols to a string. */
    static decompress(compressed) {
        // Build the dictionary.
        var dictSize = 256
        var dictionary = {}
        for (i in 0...dictSize) dictionary[i] = String.fromByte(i)
        var w = String.fromByte(compressed[0])
        var result = w
        for (k in compressed.skip(1)) {
            var entry
            if (dictionary.containsKey(k)) {
                entry = dictionary[k]
            } else if (k == dictSize) {
                entry = w + String.fromByte(w.bytes[0])
            } else {
                Fiber.abort("Bad compressed k: %(k)")
            }
            result = result + entry

            // Add w + entry[0] to the dictionary.
            dictionary[dictSize] = w + String.fromByte(entry.bytes[0])
            dictSize = dictSize + 1
            w = entry
        }
        return result
    }
}

var compressed = LZW.compress("TOBEORNOTTOBEORTOBEORNOT")
System.print(compressed)
var decompressed = LZW.decompress(compressed)
System.print(decompressed)
