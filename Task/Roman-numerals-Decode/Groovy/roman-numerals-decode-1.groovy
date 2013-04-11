enum RomanDigits {
    I(1), V(5), X(10), L(50), C(100), D(500), M(1000);

    private magnitude;
    private RomanDigits(magnitude) { this.magnitude = magnitude }

    String toString() { super.toString() + "=${magnitude}" }

    static BigInteger parse(String numeral) {
        assert numeral != null && !numeral.empty
        def digits = (numeral as List).collect {
            RomanDigits.valueOf(it)
        }
        def L = digits.size()
        (0..<L).inject(0g) { total, i ->
            def sign = (i == L - 1 || digits[i] >= digits[i+1]) ? 1 : -1
            total + sign * digits[i].magnitude
        }
    }
}
