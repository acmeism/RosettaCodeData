import Foundation

extension Decimal {
  func rounded(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
    var result = Decimal()
    var localCopy = self
    NSDecimalRound(&result, &localCopy, scale, roundingMode)
    return result
  }
}

let costHamburgers = Decimal(4000000000000000) * Decimal(5.50)
let costMilkshakes = Decimal(2) * Decimal(2.86)
let totalBeforeTax = costMilkshakes + costHamburgers
let taxesToBeCollected = (Decimal(string: "0.0765")! * totalBeforeTax).rounded(2, .bankers)

print("Price before tax: $\(totalBeforeTax)")
print("Total tax to be collected: $\(taxesToBeCollected)")
print("Total with taxes: $\(totalBeforeTax + taxesToBeCollected)")
