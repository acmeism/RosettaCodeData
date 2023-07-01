var size = 1 << 4
for (y in size-1..0) {
    System.write(" " * y)
    for (x in 0...size-y) System.write((x&y != 0) ? "  " : "* ")
    System.print()
}
