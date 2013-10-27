def middleThree(Number number) {
    def text = Math.abs(number) as String
    assert text.size() >= 3 : "'$number' must be more than 3 numeric digits"
    assert text.size() % 2 == 1 : "'$number' must have an odd number of digits"

    int start = text.size() / 2 - 1
    text[start..(start+2)]
}
