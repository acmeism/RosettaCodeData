import Foundation

private let stx = "\u{2}"
private let etx = "\u{3}"

func bwt(_ str: String) -> String? {
  guard !str.contains(stx), !str.contains(etx) else {
    return nil
  }

  let ss = stx + str + etx
  let table = ss.indices.map({i in ss[i...] + ss[ss.startIndex..<i] }).sorted()

  return String(table.map({str in str.last!}))
}

func ibwt(_ str: String) -> String? {
  let len = str.count
  var table = Array(repeating: "", count: len)

  for _ in 0..<len {
    for i in 0..<len {
      table[i] = String(str[str.index(str.startIndex, offsetBy: i)]) + table[i]
    }

    table.sort()
  }

  for row in table where row.hasSuffix(etx) {
    return String(row.dropFirst().dropLast())
  }

  return nil
}


func readableBwt(_ str: String) -> String {
  return str.replacingOccurrences(of: "\u{2}", with: "^").replacingOccurrences(of: "\u{3}", with: "|")
}

let testCases = [
  "banana",
  "appellee",
  "dogwood",
  "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
  "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
  "\u{2}ABC\u{3}"
]

for test in testCases {
  let b = bwt(test) ?? "error"
  let c = ibwt(b) ?? "error"

  print("\(readableBwt(test)) -> \(readableBwt(b)) -> \(readableBwt(c))")
}
