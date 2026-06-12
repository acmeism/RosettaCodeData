import Foundation

// highest power of 2 that divides a given number
func hpo2(_ n: Int) -> Int {
    n & -n
}

// base 2 logarithm of the highest power of 2 dividing a given number
func lhpo2(_ n: Int) -> Int {
    var q: Int = 0
    var m: Int = hpo2(n)
    while m % 2 == 0 {
        m >>= 1
        q += 1
    }
    return q
}

// nim-sum of two numbers
func nimSum(x: Int, y: Int) -> Int {
    x ^ y
}

// nim-product of two numbers
func nimProduct(x: Int, y: Int) -> Int {
    if x < 2 || y < 2 {
        return x * y
    }
    var h = hpo2(x);
    if x > h {
        return nimProduct(x: h, y: y) ^ nimProduct(x: x ^ h, y: y)
    }
    if hpo2(y) < y {
        return nimProduct(x: y, y: x)
    }
    let xp = lhpo2(x)
    let yp = lhpo2(y)
    let comp = xp & yp
    if comp == 0 {
        return x * y
    }
    h = hpo2(comp)
    return nimProduct(x: nimProduct(x: x >> h, y: y >> h), y: 3 << (h - 1))
}

func printTable(n: Int, op: Character, function: (Int, Int) -> Int) {
    print(" \(op) |", terminator: "")
    for a in 0...n {
        print(String(format: "%3d", a), terminator: "")
    }
    print("\n--- -", terminator: "")
    for _ in 0...n {
        print("---", terminator: "")
    }
    print()
    for b in 0...n {
        print("\(String(format: "%2d", b)) |", terminator: "")
        for a in 0...n {
            print(String(format: "%3d", function(a, b)), terminator: "")
        }
        print()
    }
}

printTable(n: 15, op: "+", function: nimSum)
print()
printTable(n: 15, op: "*", function: nimProduct)
let a: Int = 21508
let b: Int = 42689
print("\n\(a) + \(b) = \(nimSum(x: a, y: b))")
print("\(a) * \(b) = \(nimProduct(x: a, y: b))")
