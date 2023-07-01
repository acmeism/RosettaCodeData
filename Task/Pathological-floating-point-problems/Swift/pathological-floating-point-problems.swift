extension Numeric where Self: Strideable {
  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

protocol PathologicalFloat: SignedNumeric, Strideable, ExpressibleByFloatLiteral {
  static var e: Self { get }

  static func /(_ lhs: Self, _ rhs: Self) -> Self
}

extension Double: PathologicalFloat {
  static var e: Double { Double("2.71828182845904523536028747135266249")! }
}

extension Float: PathologicalFloat {
  static var e: Float { Float("2.7182818284590")! }
}

extension Decimal: PathologicalFloat {
  static var e: Decimal { Decimal(string: "2.71828182845904523536028747135266249")! }
}

extension BDouble: PathologicalFloat {
  static var e: BDouble { BDouble("2.71828182845904523536028747135266249")! }

  public func advanced(by n: BDouble) -> BDouble { self + n }
  public func distance(to other: BDouble) -> BDouble { abs(self - other) }
}

func badSequence<T: PathologicalFloat>(n: Int) -> T {
  guard n != 1 else { return 2 }
  guard n != 2 else { return -4 }

  var a: T = 2, b: T = -4

  for _ in stride(from: 2, to: n, by: 1) {
    (a, b) = (b, 111 - 1130  / b + 3000 / (a * b))
  }

  return b
}

func chaoticBank<T: PathologicalFloat>(years: T) -> T {
  var balance = T.e - 1

  for year: T in stride(from: 1, through: 25, by: 1) {
    balance = (balance * year) - 1
  }

  return balance
}

func rumpFunction<T: PathologicalFloat>(_ a: T, _ b: T) -> T {
  let aSquared = a.power(2)
  let bSix = b.power(6)

  let f1 = 333.75 * bSix
  let f2 = aSquared * (11 * aSquared * b.power(2) - bSix - 121 * b.power(4) - 2)
  let f3 = 5.5 * b.power(8) + a / (2 * b)

  return f1 + f2 + f3
}

func fmt<T: CVarArg>(_ n: T) -> String { String(format: "%16.16f", n) }

print("Bad sequence")
for i in [3, 4, 5, 6, 7, 8, 20, 30, 50, 100] {
  let vFloat: Float = badSequence(n: i)
  let vDouble: Double = badSequence(n: i)
  let vDecimal: Decimal = badSequence(n: i)
  let vBigDouble: BDouble = badSequence(n: i)

  print("v(\(i)) as Float \(fmt(vFloat)); as Double = \(fmt(vDouble)); as Decimal = \(vDecimal); as BDouble = \(vBigDouble.decimalExpansion(precisionAfterDecimalPoint: 16, rounded: false))")
}


let bankFloat: Float = chaoticBank(years: 25)
let bankDouble: Double = chaoticBank(years: 25)
let bankDecimal: Decimal = chaoticBank(years: 25)
let bankBigDouble: BDouble = chaoticBank(years: 25)

print("\nChaotic bank")
print("After 25 years your bank will be \(bankFloat) if stored as a Float")
print("After 25 years your bank will be \(bankDouble) if stored as a Double")
print("After 25 years your bank will be \(bankDecimal) if stored as a Decimal")
print("After 25 years your bank will be \(bankBigDouble.decimalExpansion(precisionAfterDecimalPoint: 16, rounded: false)) if stored as a BigDouble")

let rumpFloat: Float = rumpFunction(77617.0, 33096.0)
let rumpDouble: Double = rumpFunction(77617.0, 33096.0)
let rumpDecimal: Decimal = rumpFunction(77617.0, 33096.0)
let rumpBigDouble: BDouble = rumpFunction(77617.0, 33096.0)

print("\nRump's function")
print("rump(77617.0, 33096.0) as Float \(rumpFloat); as Double = \(rumpDouble); as Decimal = \(rumpDecimal); as BDouble = \(rumpBigDouble.decimalExpansion(precisionAfterDecimalPoint: 16, rounded: false))")
