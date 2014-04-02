def compress = { text ->
    def dictionary = (1..255).inject([:]) { map, ch -> map."${(char)ch}" = ch; map }
    def w = '', compressed = []
    text.each { ch ->
        def wc = "$w$ch"
        if (dictionary[wc]) {
            w = wc
        } else {
            compressed << dictionary[w]
            dictionary[wc] = dictionary.size() + 1
            w = "$ch"
        }
    }
    if (w) { compressed << dictionary[w] }
    compressed
}

def decompress = { compressed ->
    def dictionary = (1..255).inject([:])  { map, ch -> map[ch] = "${(char)ch}"; map }
    String w = "${(char)compressed.remove(0)}"
    StringBuffer result = new StringBuffer(w)
    compressed.each { k ->
        String entry = dictionary[k]
        if (!entry) {
            if (k != dictionary.size()) throw new IllegalArgumentException("Bad compressed k $k")
            entry = "$w${w[0]}"
        }
        result << entry
        dictionary[dictionary.size() + 1] = "$w${entry[0]}"
        w = entry
    }
    result.toString()
}
