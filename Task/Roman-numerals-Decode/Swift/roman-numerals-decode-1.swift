extension Int {
    init(romanNumerals: String) {
        let values = [
            ( "M", 1000),
            ("CM",  900),
            ( "D",  500),
            ("CD",  400),
            ( "C",  100),
            ("XC",   90),
            ( "L",   50),
            ("XL",   40),
            ( "X",   10),
            ("IX",    9),
            ( "V",    5),
            ("IV",    4),
            ( "I",    1),
        ]

        self = 0
        var raw = romanNumerals
        for (digit, value) in values {
            while raw.hasPrefix(digit) {
                self += value
                raw.removeFirst(digit.count)
            }
        }
    }
}
