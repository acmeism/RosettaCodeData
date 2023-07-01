def makeHornerPolynomial(coefficients :List) {
    def indexing := (0..!coefficients.size()).descending()
    return def hornerPolynomial(x) {
        var acc := 0
        for i in indexing {
            acc := acc * x + coefficients[i]
        }
        return acc
    }
}
