extension Int {
  private static let bigNames = [
    1_000: "thousand",
    1_000_000: "million",
    1_000_000_000: "billion",
    1_000_000_000_000: "trillion",
    1_000_000_000_000_000: "quadrillion",
    1_000_000_000_000_000_000: "quintillion"
  ]

  private static let names = [
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
    16: "sixteen",
    17: "seventeen",
    18: "eighteen",
    19: "nineteen",
    20: "twenty",
    30: "thirty",
    40: "forty",
    50: "fifty",
    60: "sixty",
    70: "seventy",
    80: "eighty",
    90: "ninety"
  ]

  public var numberName: String {
    guard self != 0 else {
      return "zero"
    }

    let neg = self < 0
    let maxNeg = self == Int.min
    var nn: Int

    if maxNeg {
      nn = -(self + 1)
    } else if neg {
      nn = -self
    } else {
      nn = self
    }

    var digits3 = [Int](repeating: 0, count: 7)

    for i in 0..<7 {
      digits3[i] = (nn % 1000)
      nn /= 1000
    }

    func threeDigitsToText(n: Int) -> String {
      guard n != 0 else {
        return ""
      }

      var ret = ""

      let hundreds = n / 100
      let remainder = n % 100

      if hundreds > 0 {
        ret += "\(Int.names[hundreds]!) hundred"

        if remainder > 0 {
          ret += " "
        }
      }

      if remainder > 0 {
        let tens = remainder / 10
        let units = remainder % 10

        if tens > 1 {
          ret += Int.names[tens * 10]!

          if units > 0 {
            ret += "-\(Int.names[units]!)"
          }
        } else {
          ret += Int.names[remainder]!
        }
      }

      return ret
    }

    let strings = (0..<7).map({ threeDigitsToText(n: digits3[$0]) })
    var name = strings[0]
    var big = 1000

    for i in 1...6 {
      if digits3[i] > 0 {
        var name2 = "\(strings[i]) \(Int.bigNames[big]!)"

        if name.count > 0 {
          name2 += ", "
        }

        name = name2 + name
      }

      big &*= 1000
    }

    if maxNeg {
      name = String(name.dropLast(5) + "eight")
    }

    return neg ? "minus \(name)" : name
  }
}

let nums = [
  0, 1, 7, 10, 18, 22, 67, 99, 100, 105, 999, -1056, 1000005000,
  2074000000, 1234000000745003, Int.min
]

for number in nums {
  print("\(number) => \(number.numberName)")
}
