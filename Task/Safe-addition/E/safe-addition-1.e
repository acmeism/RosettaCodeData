def makeInterval(a :float64, b :float64) {
    require(a <= b)
    def interval {
        to least() { return a }
        to greatest() { return b }
        to __printOn(out) {
            out.print("[", a, ", ", b, "]")
        }
        to add(other) {
            require(a <=> b)
            require(other.least() <=> other.greatest())
            def result := a + other.least()
            return makeInterval(result.previous(), result.next())
        }
    }
    return interval
}
