for i in 1...10 {
    println("\(i): \(properDivs(i))")
}

var (num, max) = (0,0)

for i in 1...20_000 {

    let count = properDivs(i).count
    if (count > max) { (num, max) = (i, count) }
}

println("\(num): \(max)")
