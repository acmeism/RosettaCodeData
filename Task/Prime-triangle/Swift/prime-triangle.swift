import Foundation

func isPrime(_ n: Int) -> Bool {
    guard n > 0 && n < 64 else {
        return false
    }
    return ((UInt64(1) << n) & 0x28208a20a08a28ac) != 0
}

func primeTriangleRow(_ a: inout [Int], start: Int, length: Int) -> Bool {
    if length == 2 {
        return isPrime(a[start] + a[start + 1])
    }
    for i in stride(from: 1, to: length - 1, by: 2) {
        let index = start + i
        if isPrime(a[start] + a[index]) {
            a.swapAt(index, start + 1)
            if primeTriangleRow(&a, start: start + 1, length: length - 1) {
                return true
            }
            a.swapAt(index, start + 1)
        }
    }
    return false
}

func primeTriangleCount(_ a: inout [Int], start: Int, length: Int) -> Int {
    var count = 0
    if length == 2 {
        if isPrime(a[start] + a[start + 1]) {
            count += 1
        }
    } else {
        for i in stride(from: 1, to: length - 1, by: 2) {
            let index = start + i
            if isPrime(a[start] + a[index]) {
                a.swapAt(index, start + 1)
                count += primeTriangleCount(&a, start: start + 1, length: length - 1)
                a.swapAt(index, start + 1)
            }
        }
    }
    return count
}

func printRow(_ a: [Int]) {
    if a.count == 0 {
        return
    }
    print(String(format: "%2d", a[0]), terminator: "")
    for x in a[1...] {
        print(String(format: " %2d", x), terminator: "")
    }
    print()
}

let startTime = CFAbsoluteTimeGetCurrent()

for n in 2...20 {
    var a = Array(1...n)
    if primeTriangleRow(&a, start: 0, length: n) {
        printRow(a)
    }
}
print()

for n in 2...20 {
    var a = Array(1...n)
    if n > 2 {
        print(" ", terminator: "")
    }
    print("\(primeTriangleCount(&a, start: 0, length: n))", terminator: "")
}
print()

let endTime = CFAbsoluteTimeGetCurrent()
print("\nElapsed time: \(endTime - startTime) seconds")
