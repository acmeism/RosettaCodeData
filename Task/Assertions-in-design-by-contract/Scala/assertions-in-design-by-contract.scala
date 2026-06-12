object AssertionsInDesignByContract extends App {
    /**
     * @param ints a non-empty array of integers
     * @return the mean magnitude of the array's elements.
     */
    def averageOfMagnitudes(ints: Array[Int]) = {
        // assertions for static analysis / runtime protoyping:
        assume(ints != null, "array must not be null")
        require(ints.length > 0, "array must be non-empty")
        // runtime exceptions when assertions are disabled:
        if (ints.length < 1) throw new IllegalArgumentException("Cannot find the average of an empty array")
        // note, the above line can implicitly throw a NullPointerException too
        val abs = ints.map(Math.abs)
        val mean = Math.round(abs.sum.toDouble / ints.length)
        assert(Math.abs(mean) >= abs.min && Math.abs(mean) <= abs.max, "magnitude must be within range")
        mean
    } ensuring(_ >= 0, "result must be non-negative (possible overflow)")

    println(averageOfMagnitudes(Array(1))) // 1
    println(averageOfMagnitudes(Array(1,3))) // 2
    println(averageOfMagnitudes(null)) // java.lang.AssertionError: assumption failed: array must not be null
    println(averageOfMagnitudes(Array())) // java.lang.IllegalArgumentException: requirement failed: array must be non-empty
    println(averageOfMagnitudes(Array(Integer.MAX_VALUE, Integer.MAX_VALUE))) // java.lang.AssertionError: assertion failed: magnitude must be within range
    println(averageOfMagnitudes(Array(Integer.MAX_VALUE, 1))) // java.lang.AssertionError: assertion failed: result must be non-negative (possible overflow)
}
