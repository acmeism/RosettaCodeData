def map = new TreeMap<Integer,Map<String,List<String>>>()

new URL('http://www.puzzlers.org/pub/wordlists/unixdict.txt').eachLine { word ->
    def size = - word.size()
    map[size] = map[size] ?: new TreeMap<String,List<String>>()
    def norm = word.toList().sort().sum()
    map[size][norm] = map[size][norm] ?: []
    map[size][norm] << word
}

def result = map.findResult { negasize, normMap ->
    def size = - negasize
    normMap.findResults { x, anagrams ->
        def n = anagrams.size()
        (0..<(n-1)).findResults { i ->
            ((i+1)..<n).findResult { j ->
                (0..<size).every { k -> anagrams[i][k] != anagrams[j][k] } \
                    ? anagrams[i,j]
                    : null
            }
        }?.flatten() ?: null
    }?.flatten() ?: null
}

if (result) {
    println "Longest deranged anagram pair: ${result}"
} else {
    println 'Deranged anagrams are a MYTH!'
}
