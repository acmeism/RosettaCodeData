pragma.enable("accumulator")
def makeMovingAverage(period) {
    def values := ([null] * period).diverge()
    var index := 0
    var count := 0

    def insert(v) {
        values[index] := v
        index := (index + 1) %% period
        count += 1
    }

    /** Returns the simple moving average of the inputs so far, or null if there
        have been no inputs. */
    def average() {
        if (count > 0) {
            return accum 0 for x :notNull in values { _ + x } / count.min(period)
        }
    }

    return [insert, average]
}
