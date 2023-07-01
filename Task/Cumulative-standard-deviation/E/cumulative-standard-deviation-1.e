def makeRunningStdDev() {
    var sum := 0.0
    var sumSquares := 0.0
    var count := 0.0

    def insert(v) {
        sum += v
        sumSquares += v ** 2
        count += 1
    }

    /** Returns the standard deviation of the inputs so far, or null if there
        have been no inputs. */
    def stddev() {
        if (count > 0) {
            def meanSquares := sumSquares/count
            def mean := sum/count
            def variance := meanSquares - mean**2
            return variance.sqrt()
        }
    }

    return [insert, stddev]
}
