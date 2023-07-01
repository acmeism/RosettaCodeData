import "/fmt" for Fmt

for (i in 0...16) {
    var j = 32 + i
    while (j < 128) {
        var k = "%(String.fromByte(j))"
        if (j == 32) {
            k = "Spc"
        } else if (j == 127) {
            k = "Del"
        }
        System.write("%(Fmt.d(3, j)) : %(Fmt.s(-3, k))   ")
        j = j + 16
    }
    System.print()
}
