BEGIN {
    # square size
    s = 256
    # the PPM image header needs 3 lines:
    # P3
    # width height
    # max colors number (per channel)
    print("P3\n", s, s, "\n", s - 1)
    # and now we generate pixels as a RGB pair in a relaxed
    # form "R G B\n"
    for (x = 0; x < s; x++) {
        for (y = 0; y < s; y++) {
            p = xor(x, y)
            print(0, p, p)
        }
    }
}
