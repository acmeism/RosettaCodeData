import Foundation

extension Int {
  func isPrime() -> Bool {

    switch self {
    case let x where x < 2:
      return false
    case 2:
      return true
    default:
      return
        self % 2 != 0 &&
        !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains {self % $0 == 0}
    }
  }
}
