def getAntiPrimes(def limit = 10) {
    def antiPrimes = []
    def candidate = 1L
    def maxFactors = 0

    while (antiPrimes.size() < limit) {
        def factors = factorize(candidate)
        if (factors.size() > maxFactors) {
            maxFactors = factors.size()
            antiPrimes << candidate
        }
        candidate++
    }
    antiPrimes
}
