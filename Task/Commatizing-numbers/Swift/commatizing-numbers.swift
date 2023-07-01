import Foundation

extension String {
  private static let commaReg = try! NSRegularExpression(pattern: "(\\.[0-9]+|[1-9]([0-9]+)?(\\.[0-9]+)?)")

  public func commatize(start: Int = 0, period: Int = 3, separator: String = ",") -> String {
    guard separator != "" else {
      return self
    }

    let sep = Array(separator)
    let startIdx = index(startIndex, offsetBy: start)
    let matches = String.commaReg.matches(in: self, range: NSRange(startIdx..., in: self))

    guard !matches.isEmpty else {
      return self
    }

    let fullMatch = String(self[Range(matches.first!.range(at: 0), in: self)!])
    let splits = fullMatch.components(separatedBy: ".")
    var ip = splits[0]

    if ip.count > period {
      var builder = Array(ip.reversed())

      for i in stride(from: (ip.count - 1) / period * period, through: period, by: -period) {
        builder.insert(contentsOf: sep, at: i)
      }

      ip = String(builder.reversed())
    }

    if fullMatch.contains(".") {
      var dp = splits[1]

      if dp.count > period {
        var builder = Array(dp)

        for i in stride(from: (dp.count - 1) / period * period, through: period, by: -period) {
          builder.insert(contentsOf: sep, at: i)
        }

        dp = String(builder)
      }

      ip += "." + dp
    }

    return String(prefix(start)) + String(dropFirst(start)).replacingOccurrences(of: fullMatch, with: ip)
  }
}

let tests = [
  "123456789.123456789",
  ".123456789",
  "57256.1D-4",
  "pi=3.14159265358979323846264338327950288419716939937510582097494459231",
  "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
  "-in Aus$+1411.8millions",
  "===US$0017440 millions=== (in 2000 dollars)",
  "123.e8000 is pretty big.",
  "The land area of the earth is 57268900(29% of the surface) square miles.",
  "Ain't no numbers in this here words, nohow, no way, Jose.",
  "James was never known as 0000000007",
  "Arthur Eddington wrote: I believe there are " +
      "15747724136275002577605653961181555468044717914527116709366231425076185631031296" +
      " protons in the universe.",
  "   $-140000±100 millions.",
  "6/9/1946 was a good year for some."
]

print(tests[0].commatize(period: 2, separator: "*"))
print(tests[1].commatize(period: 3, separator: "-"))
print(tests[2].commatize(period: 4, separator: "__"))
print(tests[3].commatize(period: 5, separator: " "))
print(tests[4].commatize(separator: "."))

for testCase in tests.dropFirst(5) {
  print(testCase.commatize())
}
