import Foundation

func isMünchhausen(_ n: Int) -> Bool {
  let nums = String(n).map(String.init).compactMap(Int.init)

  return Int(nums.map({ pow(Double($0), Double($0)) }).reduce(0, +)) == n
}

for i in 1...5000 where isMünchhausen(i) {
  print(i)
}
