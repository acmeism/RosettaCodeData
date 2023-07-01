import func Darwin.sqrt

func sqrt(x:Int) -> Int { return Int(sqrt(Double(x))) }

func properDivs(n: Int) -> [Int] {

    if n == 1 { return [] }

    var result = [Int]()

    for div in filter (1 ... sqrt(n), { n % $0 == 0 }) {

        result.append(div)

        if n/div != div && n/div != n { result.append(n/div) }
    }

    return sorted(result)

}
