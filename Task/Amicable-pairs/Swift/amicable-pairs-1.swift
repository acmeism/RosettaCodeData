import func Darwin.sqrt

func sqrt(x:Int) -> Int { return Int(sqrt(Double(x))) }

func properDivs(n: Int) -> [Int] {

    if n == 1 { return [] }

    var result = [Int]()

    for div in filter (1...sqrt(n), { n % $0 == 0 }) {

        result.append(div)

        if n/div != div && n/div != n { result.append(n/div) }
    }

    return sorted(result)

}


func sumDivs(n:Int) -> Int {

    struct Cache { static var sum = [Int:Int]() }

    if let sum = Cache.sum[n] { return sum }

    let sum = properDivs(n).reduce(0) { $0 + $1 }

    Cache.sum[n] = sum

    return sum
}

func amicable(n:Int, m:Int) -> Bool {

    if n == m { return false }

    if sumDivs(n) != m || sumDivs(m) != n { return false }

    return true
}

var pairs = [(Int, Int)]()

for n in 1 ..< 20_000 {
    for m in n+1 ... 20_000 {
        if amicable(n, m) {
            pairs.append(n, m)
            println("\(n, m)")
        }
    }
}
