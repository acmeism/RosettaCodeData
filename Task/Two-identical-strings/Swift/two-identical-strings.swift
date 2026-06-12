print("Decimal\tBinary")
var n = 1
while (true) {
    let binary = String(n, radix: 2)
    let i = n + (n << binary.count)
    if i >= 1000 {
        break
    }
    print("\(i)\t\(binary)\(binary)")
    n += 1
}
