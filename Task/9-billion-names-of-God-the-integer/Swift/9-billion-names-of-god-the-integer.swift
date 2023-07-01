var cache = [[1]]
func namesOfGod(n:Int) -> [Int] {
    for l in cache.count...n {
        var r = [0]
        for x in 1...l {
            r.append(r[r.count - 1] + cache[l - x][min(x, l-x)])
        }
        cache.append(r)
    }
    return cache[n]
}

func row(n:Int) -> [Int] {
    let r = namesOfGod(n)
    var returnArray = [Int]()
    for i in 0...n - 1 {
        returnArray.append(r[i + 1] - r[i])
    }
    return returnArray
}

println("rows:")
for x in 1...25 {
    println("\(x): \(row(x))")
}

println("\nsums: ")

for x in [23, 123, 1234, 12345] {
    cache = [[1]]
    var array = namesOfGod(x)
    var numInt = array[array.count - 1]
    println("\(x): \(numInt)")
}
