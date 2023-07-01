var rot13 = Fn.new { |s|
    var bytes = s.bytes.toList
    for (i in 0...bytes.count) {
        var c = bytes[i]
        if ((c >= 65 && c <= 77) || (c >= 97 && c <= 109)) {
            bytes[i] = c + 13
        } else if ((c >= 78 && c <= 90) || (c >= 110 && c <= 122)) {
            bytes[i] = c - 13
        }
    }
    return bytes.map { |b| String.fromByte(b) }.join()
}

System.print(rot13.call("nowhere ABJURER"))
