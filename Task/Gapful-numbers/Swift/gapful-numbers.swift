func isGapful(n: Int) -> Bool {
  guard n > 100 else {
    return true
  }

  let asString = String(n)
  let div = Int("\(asString.first!)\(asString.last!)")!

  return n % div == 0
}

let first30 = (100...).lazy.filter(isGapful).prefix(30)
let mil = (1_000_000...).lazy.filter(isGapful).prefix(15)
let bil = (1_000_000_000...).lazy.filter(isGapful).prefix(15)

print("First 30 gapful numbers: \(Array(first30))")
print("First 15 >= 1,000,000: \(Array(mil))")
print("First 15 >= 1,000,000,000: \(Array(bil))")
