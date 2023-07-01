import Foundation

func repString(_ input: String) -> [String] {
  return (1..<(1 + input.count / 2)).compactMap({x -> String? in
    let i = input.index(input.startIndex, offsetBy: x)
    return input.hasPrefix(input[i...]) ? String(input.prefix(x)) : nil
  })
}

let testCases = """
                1001110011
                1110111011
                0010010010
                1010101010
                1111111111
                0100101101
                0100100
                101
                11
                00
                1
                """.components(separatedBy: "\n")

for testCase in testCases {
  print("\(testCase) has reps: \(repString(testCase))")
}
