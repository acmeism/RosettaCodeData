guard let data = try? String(contentsOfFile: "unixdict.txt") else {
  fatalError()
}

let words = Set(data.components(separatedBy: "\n"))
let pairs = words
  .map({ ($0, String($0.reversed())) })
  .filter({ $0.0 < $0.1 && words.contains($0.1) })

print("Found \(pairs.count) pairs")
print("Five examples: \(pairs.prefix(5))")
