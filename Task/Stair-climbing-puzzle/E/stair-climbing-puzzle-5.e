def stepUpEventual() {
    # This general structure (tail-recursive def{if{when}}) is rather common
    # and probably ought to be defined in a library.

    def loop(deficit) {
        if (deficit > 0) {
            return when (def success := step()) -> {
                loop(deficit + success.pick(-1, 1))
            }
        }
    }
    return loop(1)
}
