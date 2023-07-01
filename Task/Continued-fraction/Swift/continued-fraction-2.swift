import Foundation

func calculate(n: Int, operation: (Int) -> [Int])-> Double {
    var tmp: Double = 0
    for ni in stride(from: n, to:0, by: -1) {
                var p = operation(ni)
                tmp = Double(p[1])/(Double(p[0]) + tmp);
            }
            return Double(operation(0)[0]) + tmp;
}

func sqrt (n: Int) -> [Int] {
    return [n > 0 ? 2 : 1, 1]
}

func napier (n: Int) -> [Int] {
    var res = [n > 0 ? n : 2, n > 1 ? (n - 1) : 1]
    return res
}

func pi(n: Int) -> [Int] {
    var res = [n > 0 ? 6 : 3,  Int(pow(Double(2 * n - 1), 2))]
    return res
}
print (calculate(n: 200, operation: sqrt));
print (calculate(n: 200, operation: napier));
print (calculate(n: 200, operation: pi));
