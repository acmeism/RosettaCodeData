import Foundation

func printVector(_ vec: [Int]) {
    print(vec.map { String($0) }.joined(separator: " "))
}

func factorial(_ number: Int) -> Int {
    if number > 20 {
        fatalError("Too large for 64 bit number: \(number)")
    }
    if number < 2 {
        return 1
    }
    var result = 1
    for i in 2...number {
        result *= i
    }
    return result
}

func binomial(_ n: Int, _ k: Int) -> Int {
    return factorial(n) / factorial(n - k) / factorial(k)
}

func forward(_ vec: [Int]) -> [Int] {
    var transform = [Int](repeating: 0, count: vec.count)
    for n in 0..<vec.count {
        for k in 0...n {
            transform[n] += binomial(n, k) * vec[k]
        }
    }
    return transform
}

func inverse(_ vec: [Int]) -> [Int] {
    var transform = [Int](repeating: 0, count: vec.count)
    for n in 0..<vec.count {
        for k in 0...n {
            let sign = ((n - k) & 1) != 0 ? -1 : 1
            transform[n] += binomial(n, k) * vec[k] * sign
        }
    }
    return transform
}

func selfInverting(_ vec: [Int]) -> [Int] {
    var transform = [Int](repeating: 0, count: vec.count)
    for n in 0..<vec.count {
        for k in 0...n {
            let sign = (k & 1) != 0 ? -1 : 1
            transform[n] += binomial(n, k) * vec[k] * sign
        }
    }
    return transform
}

let sequences: [[Int]] = [
    [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845],
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
    [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
]

let names = [
    "Catalan number sequence:",
    "Prime flip-flop sequence:",
    "Fibonacci number sequence:",
    "Padovan number sequence:"
]

for i in 0..<sequences.count {
    print(names[i])
    printVector(sequences[i])
    print("Forward binomial transform:")
    printVector(forward(sequences[i]))
    print("Inverse binomial transform:")
    printVector(inverse(sequences[i]))
    print("Round trip:")
    printVector(inverse(forward(sequences[i])))
    print("Self-inverting:")
    printVector(selfInverting(sequences[i]))
    print("Round trip self-inverting:")
    printVector(selfInverting(selfInverting(sequences[i])))
    print()
}

