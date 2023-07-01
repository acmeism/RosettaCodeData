import BigInt

func integerSquareRoot<T: BinaryInteger>(_ num: T) -> T {
    var x: T = num
    var q: T = 1
    while q <= x {
        q <<= 2
    }
    var r: T = 0
    while q > 1 {
        q >>= 2
        let t: T = x - r - q
        r >>= 1
        if t >= 0 {
            x = t
            r += q
        }
    }
    return r
}

func pad(string: String, width: Int) -> String {
    if string.count >= width {
        return string
    }
    return String(repeating: " ", count: width - string.count) + string
}

func commatize<T: BinaryInteger>(_ num: T) -> String {
    let string = String(num)
    var result = String()
    result.reserveCapacity(4 * string.count / 3)
    var i = 0
    for ch in string {
        if i > 0 && i % 3 == string.count % 3 {
            result += ","
        }
        result.append(ch)
        i += 1
    }
    return result
}

print("Integer square root for numbers 0 to 65:")
for n in 0...65 {
    print(integerSquareRoot(n), terminator: " ")
}

let powerWidth = 83
let isqrtWidth = 42
print("\n\nInteger square roots of odd powers of 7 from 1 to 73:")
print(" n |\(pad(string: "7 ^ n", width: powerWidth)) |\(pad(string: "isqrt(7 ^ n)", width: isqrtWidth))")
print(String(repeating: "-", count: powerWidth + isqrtWidth + 6))
var p: BigInt = 7
for n in stride(from: 1, through: 73, by: 2) {
    let power = pad(string: commatize(p), width: powerWidth)
    let isqrt = pad(string: commatize(integerSquareRoot(p)), width: isqrtWidth)
    print("\(pad(string: String(n), width: 2)) |\(power) |\(isqrt)")
    p *= 49
}
