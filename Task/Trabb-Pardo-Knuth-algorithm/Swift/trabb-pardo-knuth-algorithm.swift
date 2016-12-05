import Foundation

print("Enter 11 numbers for the Trabb─Pardo─Knuth algorithm:")

let f: (Double) -> Double = { sqrt(fabs($0)) + 5 * pow($0, 3) }

(1...11)
    .generate()
    .map { i -> Double in
        print("\(i): ", terminator: "")
        guard let s = readLine(), let n = Double(s) else { return 0 }
        return n
    }
    .reverse()
    .forEach {
        let result = f($0)
        print("f(\($0))", result > 400.0 ? "OVERFLOW" : result, separator: "\t")
    }
