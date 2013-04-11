def rleEncode(text) {
    def encoded = new StringBuilder()
    (text =~ /(([A-Z])\2*)/).each { matcher ->
        encoded.append(matcher[1].size()).append(matcher[2])
    }
    encoded.toString()
}

def rleDecode(text) {
    def decoded = new StringBuilder()
    (text =~ /([0-9]+)([A-Z])/).each { matcher ->
        decoded.append(matcher[2] * Integer.parseInt(matcher[1]))
    }
    decoded.toString()
}
