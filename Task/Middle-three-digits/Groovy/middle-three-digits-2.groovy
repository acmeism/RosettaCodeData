[123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0].each { number ->
    def text = (number as String).padLeft(10)
    try {
        println "$text: ${middleThree(number)}"
    } catch(AssertionError error) {
        println "$text cannot be converted: $error.message"
    }
}
