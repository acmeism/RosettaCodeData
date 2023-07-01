def printSierpinski(order, out) {
    def size := 2**order
    for y in (0..!size).descending() {
        out.print(" " * y)
        for x in 0..!(size-y) {
            out.print((x & y).isZero().pick("* ", "  "))
        }
        out.println()
    }
}
