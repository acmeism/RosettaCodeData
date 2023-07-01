def verifyLuhn(number, expected) {
    println "Checking: $number (${checkLuhn(number)})"
    assert expected == checkLuhn(number)
}

[49927398716: true, 49927398717: false, 1234567812345678: false, 1234567812345670: true].each { number, expected ->
    verifyLuhn number, expected
}
