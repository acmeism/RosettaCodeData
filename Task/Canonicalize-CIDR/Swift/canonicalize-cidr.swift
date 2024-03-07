import Foundation

func dottedToInt(_ dotted: String) -> UInt32 {
    let digits = dotted.split(separator: ".").map { UInt32($0)! }
    return digits.enumerated().reduce(0) { $0 + ($1.element << (24 - $1.offset * 8)) }
}

func intToDotted(_ ip: UInt32) -> String {
    let digits = [24, 16, 8, 0].map { (ip & (255 << $0)) >> $0 }
    return digits.map { String($0) }.joined(separator: ".")
}

func networkMask(_ numberOfBits: Int) -> UInt32 {
    // Explicitly use UInt32 for bitwise operations
    return UInt32((1 << numberOfBits) - 1) << (32 - numberOfBits)
}

func canonicalize(_ ip: String) -> String {
    let parts = ip.split(separator: "/")
    let dotted = String(parts[0])
    let networkBits = Int(parts[1])!

    let i = dottedToInt(dotted)
    let mask = networkMask(networkBits)
    return "\(intToDotted(i & mask))/\(networkBits)"
}

let testCases = [
    ("36.18.154.103/12", "36.16.0.0/12"),
    ("62.62.197.11/29", "62.62.197.8/29"),
    ("67.137.119.181/4", "64.0.0.0/4"),
    ("161.214.74.21/24", "161.214.74.0/24"),
    ("184.232.176.184/18", "184.232.128.0/18"),
]

for testCase in testCases {
    let (ip, expect) = testCase
    let result = canonicalize(ip)
    print("\(ip) -> \(result)")
    assert(result == expect, "Test failed for \(ip)")
}
