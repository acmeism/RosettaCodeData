import Foundation

public struct OID {
  public var val: String

  public init(_ val: String) {
    self.val = val
  }
}

extension OID: CustomStringConvertible {
  public var description: String {
    return val
  }
}

extension OID: Comparable {
  public static func < (lhs: OID, rhs: OID) -> Bool {
    let split1 = lhs.val.components(separatedBy: ".").compactMap(Int.init)
    let split2 = rhs.val.components(separatedBy: ".").compactMap(Int.init)
    let minSize = min(split1.count, split2.count)

    for i in 0..<minSize {
      if split1[i] < split2[i] {
        return true
      } else if split1[i] > split2[i] {
        return false
      }
    }

    return split1.count < split2.count
  }

  public static func == (lhs: OID, rhs: OID) -> Bool {
    return lhs.val == rhs.val
  }
}

let ids = [
  "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
  "1.3.6.1.4.1.11.2.17.5.2.0.79",
  "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
  "1.3.6.1.4.1.11150.3.4.0.1",
  "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
  "1.3.6.1.4.1.11150.3.4.0"
].map(OID.init)

for id in ids.sorted() {
  print(id)
}
