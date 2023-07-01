def hailstone = { long start ->
    def sequence = []
    while (start != 1) {
        sequence << start
        start = (start % 2l == 0l) ? start / 2l : 3l * start + 1l
    }
    sequence << start
}
