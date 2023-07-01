def binary = { i, minBits = 1 ->
    def remainder = i
    def bin = []
    while (remainder > 0 || bin.size() <= minBits) {
        bin << (remainder & 1)
        remainder >>>= 1
    }
    bin
}

println "number   binary   gray code   decode"
println "======   ======   =========   ======"
(0..31).each {
    def code = grayEncode(it)
    def decode = grayDecode(code)
    def iB = binary(it, 5)
    def cB = binary(code, 5)
    printf("    %2d    %1d%1d%1d%1d%1d       %1d%1d%1d%1d%1d       %2d",
        it, iB[4],iB[3],iB[2],iB[1],iB[0], cB[4],cB[3],cB[2],cB[1],cB[0], decode)
    println()
}
