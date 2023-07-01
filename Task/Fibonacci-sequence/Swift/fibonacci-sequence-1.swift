import Cocoa

func fibonacci(n: Int) -> Int {
    let square_root_of_5 = sqrt(5.0)
    let p = (1 + square_root_of_5) / 2
    let q = 1 / p
    return Int((pow(p,CDouble(n)) + pow(q,CDouble(n))) / square_root_of_5 + 0.5)
}

for i in 1...30 {
    println(fibonacci(i))
}
