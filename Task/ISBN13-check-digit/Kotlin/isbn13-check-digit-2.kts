describe("ISBN Utilities") {
    mapOf(
        "978-0596528126" to true,
        "978-0596528120" to false,
        "978-1788399081" to true,
        "978-1788399083" to false
    ).forEach { (input, expected) ->
        it("returns $expected for $input") {
            println("$input: ${when(isValidISBN13(input)) {
                true -> "good"
                else -> "bad"
            }}")
            assert(isValidISBN13(input) == expected)
        }
    }
}
