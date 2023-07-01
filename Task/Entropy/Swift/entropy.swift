import Foundation

func entropy(of x: String) -> Double {
  return x
    .reduce(into: [String: Int](), {cur, char in
      cur[String(char), default: 0] += 1
    })
    .values
    .map({i in Double(i) / Double(x.count) } as (Int) -> Double)
    .map({p in -p * log2(p) } as (Double) -> Double)
    .reduce(0.0, +)
}

print(entropy(of: "1223334444"))
