func properDivs1(n: Int) -> [Int] {

    return filter (1 ..< n) { n % $0 == 0 }
}
