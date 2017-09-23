def compress = { text ->
    def dictionary = (0..<256).inject([:]) { map, ch -> map."${(char)ch}" = ch; map }
    def w = '', compressed = []
    text.each { ch ->
        def wc = "$w$ch"
        if (dictionary[wc]) {
            w = wc
        } else {
            compressed << dictionary[w]
            dictionary[wc] = dictionary.size()
            w = "$ch"
        }
    }
    if (w) { compressed << dictionary[w] }
    compressed
}

def decompress = { compressed ->
    def dictionary = (0..<256).inject([:])  { map, ch -> map[ch] = "${(char)ch}"; map }
    int dictSize = 128;
    String w = "${(char)compressed[0]}"
    StringBuffer result = new StringBuffer(w)

    compressed.drop(1).each { k ->
        String entry = dictionary[k]
        if (!entry) {
            if (k != dictionary.size()) throw new IllegalArgumentException("Bad compressed k $k")
            entry = "$w${w[0]}"
        }
        result << entry

        dictionary[dictionary.size()] = "$w${entry[0]}"
        w = entry
    }

    result.toString()
}
