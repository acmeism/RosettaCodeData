BEGIN {
    x2d7 = "Goodbye, world!"
    print 0x2d7  # gawk prints "727", nawk prints "0Goodbye, world!"
    print 01327  # gawk prints "727", nawk prints "1327"
}
