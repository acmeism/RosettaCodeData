import Foundation

extension Array where Element: Comparable {
  @inlinable
  public func longestIncreasingSubsequence() -> [Element] {
    var startI = [Int](repeating: 0, count: count)
    var endI = [Int](repeating: 0, count: count + 1)
    var len = 0

    for i in 0..<count {
      var lo = 1
      var hi = len

      while lo <= hi {
        let mid = Int(ceil((Double(lo + hi)) / 2))

        if self[endI[mid]] <= self[i] {
          lo = mid + 1
        } else {
          hi = mid - 1
        }
      }

      startI[i] = endI[lo-1]
      endI[lo] = i

      if lo > len {
        len = lo
      }
    }

    var s = [Element]()
    var k = endI[len]

    for _ in 0..<len {
      s.append(self[k])
      k = startI[k]
    }

    return s.reversed()
  }
}

let l1 = [3, 2, 6, 4, 5, 1]
let l2 = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]

print("\(l1) = \(l1.longestIncreasingSubsequence())")
print("\(l2) = \(l2.longestIncreasingSubsequence())")
