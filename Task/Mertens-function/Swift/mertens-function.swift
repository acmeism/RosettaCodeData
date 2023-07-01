import Foundation

func mertensNumbers(max: Int) -> [Int] {
    var mertens = Array(repeating: 1, count: max + 1)
    for n in 2...max {
        for k in 2...n {
            mertens[n] -= mertens[n / k]
        }
    }
    return mertens
}

let max = 1000
let mertens = mertensNumbers(max: max)

let count = 200
let columns = 20
print("First \(count - 1) Mertens numbers:")
for i in 0..<count {
    if i % columns > 0 {
        print(" ", terminator: "")
    }
    print(i == 0 ? "  " : String(format: "%2d", mertens[i]), terminator: "")
    if (i + 1) % columns == 0 {
        print()
    }
}

var zero = 0, cross = 0, previous = 0
for i in 1...max {
    let m = mertens[i]
    if m == 0 {
        zero += 1
        if previous != 0 {
            cross += 1
        }
    }
    previous = m
}
print("M(n) is zero \(zero) times for 1 <= n <= \(max).")
print("M(n) crosses zero \(cross) times for 1 <= n <= \(max).")
