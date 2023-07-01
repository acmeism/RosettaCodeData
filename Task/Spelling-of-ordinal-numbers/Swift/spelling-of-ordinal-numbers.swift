fileprivate class NumberNames {
    let cardinal: String
    let ordinal: String

    init(cardinal: String, ordinal: String) {
        self.cardinal = cardinal
        self.ordinal = ordinal
    }

    func getName(_ ordinal: Bool) -> String {
        return ordinal ? self.ordinal : self.cardinal
    }

    class func numberName(number: Int, ordinal: Bool) -> String {
        guard number < 100 else {
            return ""
        }
        if number < 20 {
            return smallNames[number].getName(ordinal)
        }
        if number % 10 == 0 {
            return tens[number/10 - 2].getName(ordinal)
        }
        var result = tens[number/10 - 2].getName(false)
        result += "-"
        result += smallNames[number % 10].getName(ordinal)
        return result
    }

    static let smallNames = [
        NumberNames(cardinal: "zero", ordinal: "zeroth"),
        NumberNames(cardinal: "one", ordinal: "first"),
        NumberNames(cardinal: "two", ordinal: "second"),
        NumberNames(cardinal: "three", ordinal: "third"),
        NumberNames(cardinal: "four", ordinal: "fourth"),
        NumberNames(cardinal: "five", ordinal: "fifth"),
        NumberNames(cardinal: "six", ordinal: "sixth"),
        NumberNames(cardinal: "seven", ordinal: "seventh"),
        NumberNames(cardinal: "eight", ordinal: "eighth"),
        NumberNames(cardinal: "nine", ordinal: "ninth"),
        NumberNames(cardinal: "ten", ordinal: "tenth"),
        NumberNames(cardinal: "eleven", ordinal: "eleventh"),
        NumberNames(cardinal: "twelve", ordinal: "twelfth"),
        NumberNames(cardinal: "thirteen", ordinal: "thirteenth"),
        NumberNames(cardinal: "fourteen", ordinal: "fourteenth"),
        NumberNames(cardinal: "fifteen", ordinal: "fifteenth"),
        NumberNames(cardinal: "sixteen", ordinal: "sixteenth"),
        NumberNames(cardinal: "seventeen", ordinal: "seventeenth"),
        NumberNames(cardinal: "eighteen", ordinal: "eighteenth"),
        NumberNames(cardinal: "nineteen", ordinal: "nineteenth")
    ]

    static let tens = [
        NumberNames(cardinal: "twenty", ordinal: "twentieth"),
        NumberNames(cardinal: "thirty", ordinal: "thirtieth"),
        NumberNames(cardinal: "forty", ordinal: "fortieth"),
        NumberNames(cardinal: "fifty", ordinal: "fiftieth"),
        NumberNames(cardinal: "sixty", ordinal: "sixtieth"),
        NumberNames(cardinal: "seventy", ordinal: "seventieth"),
        NumberNames(cardinal: "eighty", ordinal: "eightieth"),
        NumberNames(cardinal: "ninety", ordinal: "ninetieth")
    ]
}

fileprivate class NamedPower {
    let cardinal: String
    let ordinal: String
    let number: UInt64

    init(cardinal: String, ordinal: String, number: UInt64) {
        self.cardinal = cardinal
        self.ordinal = ordinal
        self.number = number
    }

    func getName(_ ordinal: Bool) -> String {
        return ordinal ? self.ordinal : self.cardinal
    }

    class func getNamedPower(_ number: UInt64) -> NamedPower {
        for i in 1..<namedPowers.count {
            if number < namedPowers[i].number {
                return namedPowers[i - 1]
            }
        }
        return namedPowers[namedPowers.count - 1]
    }

    static let namedPowers = [
        NamedPower(cardinal: "hundred", ordinal: "hundredth",
                   number: 100),
        NamedPower(cardinal: "thousand", ordinal: "thousandth",
                   number: 1000),
        NamedPower(cardinal: "million", ordinal: "millionth",
                   number: 1000000),
        NamedPower(cardinal: "billion", ordinal: "billionth",
                   number: 1000000000),
        NamedPower(cardinal: "trillion", ordinal: "trillionth",
                   number: 1000000000000),
        NamedPower(cardinal: "quadrillion", ordinal: "quadrillionth",
                   number: 1000000000000000),
        NamedPower(cardinal: "quintillion", ordinal: "quintillionth",
                   number: 1000000000000000000)
    ]
}

public func numberName(number: UInt64, ordinal: Bool) -> String {
    if number < 100 {
        return NumberNames.numberName(number: Int(truncatingIfNeeded: number),
                                      ordinal: ordinal)
    }
    let p = NamedPower.getNamedPower(number)
    var result = numberName(number: number/p.number, ordinal: false)
    result += " "
    if number % p.number == 0 {
        result += p.getName(ordinal)
    } else {
        result += p.getName(false)
        result += " "
        result += numberName(number: number % p.number, ordinal: ordinal)
    }
    return result
}

func printOrdinal(_ number: UInt64) {
    print("\(number): \(numberName(number: number, ordinal: true))")
}

printOrdinal(1)
printOrdinal(2)
printOrdinal(3)
printOrdinal(4)
printOrdinal(5)
printOrdinal(11)
printOrdinal(15)
printOrdinal(21)
printOrdinal(42)
printOrdinal(65)
printOrdinal(98)
printOrdinal(100)
printOrdinal(101)
printOrdinal(272)
printOrdinal(300)
printOrdinal(750)
printOrdinal(23456)
printOrdinal(7891233)
printOrdinal(8007006005004003)
