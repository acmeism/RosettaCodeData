Number.metaClass.getSelfReferentialSequence = {
    def number = delegate as String; def sequence = []

    while (!sequence.contains(number)) {
        sequence << number
        def encoded = new StringBuilder()
        ((number as List).sort().join('').reverse() =~ /(([0-9])\2*)/).each { matcher, text, digit ->
            encoded.append(text.size()).append(digit)
        }
        number = encoded.toString()
    }
    sequence
}
