func raise<T: Numeric>(_ base: T, to exponent: Int) -> T {
    precondition(exponent >= 0, "Exponent has to be nonnegative")
    return Array(repeating: base, count: exponent).reduce(1, *)
}

infix operator **: MultiplicationPrecedence

func **<T: Numeric>(lhs: T, rhs: Int) -> T {
    return raise(lhs, to: rhs)
}

let someFloat: Float = 2
let someInt: Int = 10

assert(raise(someFloat, to: someInt) == 1024)
assert(someFloat ** someInt == 1024)
assert(raise(someInt, to: someInt) == 10000000000)
assert(someInt ** someInt == 10000000000)
