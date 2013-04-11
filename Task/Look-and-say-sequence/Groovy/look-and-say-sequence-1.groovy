def lookAndSay(sequence) {
    def encoded = new StringBuilder()
    (sequence.toString() =~ /(([0-9])\2*)/).each { matcher ->
        encoded.append(matcher[1].size()).append(matcher[2])
    }
    encoded.toString()
}
