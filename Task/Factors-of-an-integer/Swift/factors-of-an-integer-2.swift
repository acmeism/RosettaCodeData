import func Darwin.sqrt

func sqrt(x:Int) -> Int { return Int(sqrt(Double(x))) }

func factors(n: Int) -> [Int] {

    var result = [Int]()

    for factor in filter (1...sqrt(n), { n % $0 == 0 }) {

        result.append(factor)

        if n/factor != factor { result.append(n/factor) }
    }

    return sorted(result)

}
