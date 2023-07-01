def checksum(text) {
    assert text.size() == 6 && !text.toUpperCase().find(/[AEIOU]+/) : "Invalid SEDOL text: $text"

    def sum = 0
    (0..5).each { index ->
        sum +=  Character.digit(text.charAt(index), 36) * [1, 3, 1, 7, 3, 9][index]
    }
    text + (10 - (sum % 10)) % 10
}
String.metaClass.sedol = { this.&checksum(delegate) }
