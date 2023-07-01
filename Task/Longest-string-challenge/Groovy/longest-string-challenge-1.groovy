def longer = { a, b ->
    def aa = a, bb = b
    while (bb && aa) {
        bb = bb.substring(1)
        aa = aa.substring(1)
    }
    aa ? a : b
}

def longestStrings
longestStrings = { BufferedReader source, String longest = '' ->
    String current = source.readLine()
    def finalLongest = current == null \
        ? longest \
        : longestStrings(source,longer(current,longest))
    if (longer(finalLongest, current) == current) {
        println current
    }
    return finalLongest
}
