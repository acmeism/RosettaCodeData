func factors(n: Int) -> [Int] {

    return filter(1...n) { n % $0 == 0 }
}
