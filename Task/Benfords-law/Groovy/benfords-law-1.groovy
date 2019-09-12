def tallyFirstDigits = { size, generator ->
    def population = (0..<size).collect { generator(it) }
    def firstDigits = [0]*10
    population.each { number ->
        firstDigits[(number as String)[0] as int] ++
    }
    firstDigits
}
