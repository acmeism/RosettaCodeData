def testNumbers = [ 0x200000, 0x1fffff, 1, 127, 128, 589723405834L ]

testNumbers.each { a ->
    def octets = octetify(a)
    octets.each { printf "0x%02x ", it }; println ()
    def a1 = deoctetify(octets)
    assert a1 == a
}
